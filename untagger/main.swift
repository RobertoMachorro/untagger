//
//  main.swift
//  untagger
//
//  Created by Roberto Machorro on 3/16/23.
//

import Foundation
import SwiftSoup

guard CommandLine.arguments.count == 3 else {
	fatalError("Missing input file and folder/sub-menu name.")
}

let filePath = CommandLine.arguments[1]
let seekFolderName = CommandLine.arguments[2]

do {
	let html = try String(contentsOfFile: filePath, encoding: .utf8)

	let doc: Document = try SwiftSoup.parse(html)
	let folders = try doc.select("dt")

	print("\"Title\",\"Hyperlink\"")
	for folder in folders {
		let name = try folder.select("h3").first()?.html()
		if let name: String = name, name == seekFolderName {
			for link in try folder.select("a") {
				let caption = try link.text()
				let href = try link.attr("href")
				print("\"\(caption)\",\"\(href)\"")
			}
		}
	}
} catch {
	print(error)
}
