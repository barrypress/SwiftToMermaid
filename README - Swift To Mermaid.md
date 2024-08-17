#  Readme - Swift To Mermaid 

## Bugs

* 

## Improvements

* Include the type in the line reporting an instance or static variable
* Implement:
  - A settings file that enables searching / excluding paths, excluding classes / structs
  - The ability to save the image, especially if it can be done in one layer per type or otherwise be able to manipulate it to rearrange / make narrower
  - Unit tests
  - Open Recent...>
  - Read and display `.mermaid` files

## Problems

* The SwiftToMermaid tests crash in SourceKitten

## C4-PlantUML

See [C4-PlantUML C4 Core Diagrams](https://github.com/plantuml-stdlib/C4-PlantUML/blob/master/samples/C4CoreDiagrams.md) 
for ideas on what can be done. Not sure how to render, exactly, yet

Also see the [C4-PlantUML README](https://github.com/plantuml-stdlib/C4-PlantUML/blob/master/README.md#component-diagram)

## ContentViewModel.swift

The linked code [snippet](https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.esm.min.mjs) in ContentViewModel.swift is 
a JavaScript app: 

```JavaScript
// Snippet from https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.esm.min.mjs
var _____WB$wombat$assign$function_____ = function(name) {
    return (self._wb_wombat && self._wb_wombat.local_init && self._wb_wombat.local_init(name)) || self[name];
};

if (!self.__WB_pmw) {
    self.__WB_pmw = function(obj) {
        this.__WB_source = obj;
        return this;
    };
}

{
    let window = _____WB$wombat$assign$function_____("window");
    let self = _____WB$wombat$assign$function_____("self");
    let document = _____WB$wombat$assign$function_____("document");
    let location = _____WB$wombat$assign$function_____("location");
    let top = _____WB$wombat$assign$function_____("top");
    let parent = _____WB$wombat$assign$function_____("parent");
    let frames = _____WB$wombat$assign$function_____("frames");
    let opener = _____WB$wombat$assign$function_____("opener");

    import { b6 as f } from "./mermaid-a09fe7cd.js";
    export {
        f as default
    };
}
```

