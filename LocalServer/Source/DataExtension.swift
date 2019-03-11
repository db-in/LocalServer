/*
 *	DataExtension.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 12/24/18.
 *	Copyright 2018. All rights reserved.
 */

import Foundation
import Compression

// MARK: - Extension - Data Compression

extension Data {

// MARK: - Properties
	
	static let flags = Int32(COMPRESSION_STREAM_FINALIZE.rawValue)
	
// MARK: - Protected Methods
	
	private func processStream(_ stream: inout compression_stream,
							   _ buffer: UnsafeMutablePointer<UInt8>,
							   _ bufferSize: Int) -> Data? {
		var result = Data()
		
		if compression_stream_process(&stream, Data.flags) == COMPRESSION_STATUS_OK {
			guard stream.dst_size == 0 else { return nil }
			result.append(buffer, count: stream.dst_ptr - buffer)
			stream.dst_ptr = buffer
			stream.dst_size = bufferSize
			guard let next = processStream(&stream, buffer, bufferSize) else { return result }
			return result + next
		}
		
		result.append(buffer, count: stream.dst_ptr - buffer)
		return result
	}
	
	private func perform(operation: compression_stream_operation,
						 source: UnsafePointer<UInt8>) -> Data? {
		
		let sourceSize = count
		guard operation == COMPRESSION_STREAM_ENCODE || sourceSize > 0 else { return nil }
		
		let streamBase = UnsafeMutablePointer<compression_stream>.allocate(capacity: 1)
		var stream = streamBase.pointee
		defer { streamBase.deallocate() }
		
		let status = compression_stream_init(&stream, operation, COMPRESSION_ZLIB)
		guard status != COMPRESSION_STATUS_ERROR else { return nil }
		defer { compression_stream_destroy(&stream) }
		
		let bufferSize = Swift.max(Swift.min(sourceSize, 64 * 1024), 64)
		let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
		defer { buffer.deallocate() }
		
		stream.dst_ptr  = buffer
		stream.dst_size = bufferSize
		stream.src_ptr  = source
		stream.src_size = sourceSize
		
		return processStream(&stream, buffer, bufferSize)
	}
	
	func deflate() -> Data? {
		return withUnsafeBytes { (sourcePtr: UnsafePointer<UInt8>) -> Data? in
			return perform(operation: COMPRESSION_STREAM_ENCODE, source: sourcePtr)
		}
	}
	
	func inflate() -> Data? {
		return withUnsafeBytes { (sourcePtr: UnsafePointer<UInt8>) -> Data? in
			return perform(operation: COMPRESSION_STREAM_DECODE, source: sourcePtr)
		}
	}
}
