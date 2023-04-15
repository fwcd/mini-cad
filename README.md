# MiniCAD

A parameteric 3D modeller for macOS and iOS featuring a Swift-inspired Domain Specific Language (DSL) for modeling.

![Screenshot](Screenshots/App.png)

## Description

MiniCAD is a parametric 3D modeling program that lets users construct models with a Swift-like domain-specific language (DSL), thereby drawing inspiration from apps like OpenSCAD, Blender and Swift Playgrounds. The core idea is simple: Use geometric primitives and combine them with unions, differences and intersections to create complex shapes. The programming-centered approach provides the ability to work abstractly in terms of variables and functions, all while using a familiar syntax in a highly interactive envrionment.

On a more technical level, the app is implemented using SwiftUI and SceneKit. It uses its own recursive-descent parser and an interpreter for the DSL. The latter uses Swift Concurrency to efficiently run asynchronously. MiniCAD also includes an implementation of Computational Solid Geometry (CSG) based on Binary Space Partitioning (BSP) and ear-clipping polygon triangulation for the mesh operations. The app also supports exporting to the Standard Tesselated Geometry (STL) file format, which can be used to open models in other apps such as Preview or even to slice and 3D-print them.

## Open Source

The app includes the `Suzanne.stl` model, a demo model from the open-source 3D modeling application Blender, to showcase the import of external STL models.

Also the implementation of CSG is based on a port of the wonderfully simple and elegant JavaScript implementation by Evan Wallace: https://github.com/evanw/csg.js/ This code is MIT-licensed with Copyright (c) 2011 Evan Wallace (http://madebyevan.com/).

## See also

* [MiniBlocks](https://github.com/fwcd/mini-blocks), an open-world sandbox game built with SceneKit (my 2022 project)
* [MiniCut](https://github.com/fwcd/mini-cut), a tiny video editor built with SpriteKit (my 2021 project)
* [MiniJam](https://github.com/fwcd/mini-jam), a tiny digital audio workstation built with SwiftUI (my 2020 project)
