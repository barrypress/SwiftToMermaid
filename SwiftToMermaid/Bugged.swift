        for (ext, uti, content) in [
            ("gif", "public.gif", nil),
            ("gzip", "org.gnu.gnu-zip-archive", nil),
            ("heic", "public.heic", nil),
            ("html", "public.html", nil),
            ("jpeg", "public.jpeg", nil),
            ("json", "public.json", nil),
            ("markdown", "public.markdown", nil),
            ("md", "public.markdown", nil),
            ("pdf", "com.adobe.pdf", nil),
            ("plist", "com.apple.property-list", nil),
            ("png", "public.png", nil),
            ("swift", "public.swift-Source", nil),
            ("tar", "public.tar-archive", nil),
            ("txt", "public.plain-text", nil),
            ("text", "public.plain-text", nil),
            ("tiff", "public.tiff", nil),
            ("xml", "public.xml", nil),
            ("zip", "public.zip-archive", nil),
        ] {
            checkExtension(ext, uti, content ?? "data in file for unit tests")
        }
