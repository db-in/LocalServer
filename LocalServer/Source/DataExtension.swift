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
	
	private func process(stream: inout compression_stream,
						 _ buffer: UnsafeMutablePointer<UInt8>,
						 _ size: Int) -> Data? {
		
		var result = Data()
		
		if compression_stream_process(&stream, Data.flags) == COMPRESSION_STATUS_OK {
			guard stream.dst_size == 0 else { return nil }
			result.append(buffer, count: stream.dst_ptr - buffer)
			stream.dst_ptr = buffer
			stream.dst_size = size
			guard let next = process(stream: &stream, buffer, size) else { return result }
			return result + next
		}
		
		result.append(buffer, count: stream.dst_ptr - buffer)
		return result
	}
	
	private func perform(operation: compression_stream_operation,
						 source: UnsafeRawBufferPointer) -> Data? {
        guard let sourcePrt = source.bindMemory(to: UInt8.self).baseAddress else {
            return nil
        }
        
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
		
		stream.src_ptr  = sourcePrt
		stream.src_size = sourceSize
		stream.dst_ptr  = buffer
		stream.dst_size = bufferSize
		
		return process(stream: &stream, buffer, bufferSize)
	}
	
	func deflate() -> Data? {
		return withUnsafeBytes {
            perform(operation: COMPRESSION_STREAM_ENCODE, source: $0)
        }
	}
	
	func inflate() -> Data? {
		return withUnsafeBytes { perform(operation: COMPRESSION_STREAM_DECODE, source: $0) }
	}
}
