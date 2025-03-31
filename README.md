# Anaglyph Generator

Project developed in the context of the **Computer Systems Architecture** course, with the goal of generating anaglyph images from stereoscopic images. This project explores image processing techniques and graphic data manipulation to generate 3D effects.

## Developer
- **Pedro Correia**

## Project Description
The **Anaglyph Generator** is a tool that converts stereoscopic images (two images with a slight difference in perspective) into anaglyph images. Anaglyph images are 3D images viewable with special glasses, one with a red lens and the other with a cyan lens. The project focuses on the application of **Computer Systems Architecture** concepts, utilizing parallel image processing techniques and performance optimization.

## Features
- **Conversion of stereoscopic images to anaglyphs**: The project allows the generation of a 3D image from two 2D images (one for each eye).
- **Customization options**: The user can adjust parameters such as color intensity and depth to improve the 3D effect of the image.
- **Support for different image formats**: The anaglyph generator supports common image formats such as `.jpg`, `.png`, `.bmp`.

The **Anaglyph Generator** is implemented in **x86-64bit assembly** in the **Intel syntax** for **NASM**. It creates an anaglyph from two stereogram images, using either a color algorithm or a mono algorithm.

---
## Compilation

```bash
nasm -F dwarf -f elf64 Biblioteca.asm
```
```bash
nasm -F dwarf -f elf64 Anaglyph_Gen.asm
```
```bash
ld Anaglyph_Gen.o Biblioteca.o -o
```


---
## Execution

```bash
./Anaglyph_Gen C [left_image.bmp] [right_image.bmp] [final_anaglyph_desired_name.bmp]
```
```bash
./Anaglyph_Gen M [left_image.bmp] [right_image.bmp] [final_anaglyph_desired_name.bmp]
```
 
