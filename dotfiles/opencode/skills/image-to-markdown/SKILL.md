---
name: image-to-markdown
description: Convert one or more provided images into clean Markdown. Use when the user uploads, pastes, or references an image and asks to transcribe, recreate, or convert its visible content into Markdown, including headings, paragraphs, lists, tables, code, and math notation.
---

# Image to Markdown

## Task

Convert provided image content into Markdown.

## Requirements

- Return only the Markdown output.
- Do not include explanations, commentary, code fences, or surrounding text.
- Preserve the visible structure of the image as closely as possible.
- Use Markdown headings, lists, tables, blockquotes, and code blocks where appropriate.
- For math, use `$...$` for inline math and `$$...$$` for display math.
- Do not use `\(...\)` or `\[...\]` for math.
- If text is unclear or unreadable, mark it as `[unclear]`.
- If the image contains diagrams or non-text visual elements, describe them briefly in Markdown only when needed to preserve meaning.
