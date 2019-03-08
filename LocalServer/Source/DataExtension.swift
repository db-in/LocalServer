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
	
// MARK: - Protected Methods
	
	private func perform(operation: compression_stream_operation,
						 algorithm: compression_algorithm,
						 source: UnsafePointer<UInt8>,
						 sourceSize: Int) -> Data? {
		
		guard operation == COMPRESSION_STREAM_ENCODE || sourceSize > 0 else { return nil }
		
		let streamBase = UnsafeMutablePointer<compression_stream>.allocate(capacity: 1)
		var stream = streamBase.pointee
		defer { streamBase.deallocate() }
		
		let status = compression_stream_init(&stream, operation, algorithm)
		guard status != COMPRESSION_STATUS_ERROR else { return nil }
		defer { compression_stream_destroy(&stream) }
		
		let bufferSize = Swift.max(Swift.min(sourceSize, 64 * 1024), 64)
		let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
		defer { buffer.deallocate() }
		
		stream.dst_ptr  = buffer
		stream.dst_size = bufferSize
		stream.src_ptr  = source
		stream.src_size = sourceSize
		
		var res = Data()
		let flags: Int32 = Int32(COMPRESSION_STREAM_FINALIZE.rawValue)
		
		while true {
			switch compression_stream_process(&stream, flags) {
			case COMPRESSION_STATUS_OK:
				guard stream.dst_size == 0 else { return nil }
				res.append(buffer, count: stream.dst_ptr - buffer)
				stream.dst_ptr = buffer
				stream.dst_size = bufferSize
			case COMPRESSION_STATUS_END:
				res.append(buffer, count: stream.dst_ptr - buffer)
				return res
			default:
				return nil
			}
		}
	}
	
	func deflate() -> Data? {
		return withUnsafeBytes { (sourcePtr: UnsafePointer<UInt8>) -> Data? in
			return perform(operation: COMPRESSION_STREAM_ENCODE,
						   algorithm: COMPRESSION_ZLIB,
						   source: sourcePtr,
						   sourceSize: count)
		}
	}
	
	func inflate() -> Data? {
		return withUnsafeBytes { (sourcePtr: UnsafePointer<UInt8>) -> Data? in
			return perform(operation: COMPRESSION_STREAM_DECODE,
						   algorithm: COMPRESSION_ZLIB,
						   source: sourcePtr,
						   sourceSize: count)
		}
	}
}
