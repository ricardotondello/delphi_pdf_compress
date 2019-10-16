# delphi_pdf_compress
# gsCompressPDF
Compression of PDF files "multithread" in console application 
You can get only .exe file (inside bin folder) and nothing else is needded to run.

If you want to modify:
	- Made in Delphi using GhostScript (Seattle>Tokio but should build in any version) 

## How it works

**Ghostscripts create a new PDF file, compressing and optimizing file Fonts, Images and MetaInfos, by reducing quality of Images. Changing not embedded fonts for smaller versions of the same or similiar font.**

## Usage


calling app (shell, cmd, prompt):

```
gsCompressPDF.exe PathInput PathOutput PathLog
```

calling by Shell on Delphi (shell, cmd, prompt):

```
ShellExecute(Handle, PChar('OPEN'), PChar('gsCompressPDF.exe'), PChar('input.pdf output.pdf'), nil, SW_SHOWNORMAL, Code)
```

** Code returns windows shell code. (Code > 32) means sucess. **

## Parameters:

	PathInput = Full Path of PDF file with extension (eq. C:\temp\file.pdf). If only the name is provided, gsCompressPDF will look on his own folder for the PDF file.
	
	PathOutput = Full Path that compressed file will be write on, with extension. If only the name is provided, gsCompressPDF will create a output file on his own folder. (eq. C:\temp\file_compressed.pdf)

	PathLog = Optional parameter. Use this if you want to have log files in a diferent folder then /logs. The application create one log per file.
	
#### If you want to split the original file in multiples files, you can include %d on the output name, so the app create a new file for each page of the input pdf. 

**Example**

```
gsCompressPDF.exe inputpages.pdf output%d.pdf
```

It creates one file per page replacing page number instead of %d:
output1.pdf
output2.pdf
output3.pdf
.......

### Inside parameters pass to GhostScript

  -dSAFER															
**---(Avoiding restrictions on unknown folders)**

  -dBATCH

  -dNOPAUSE

  -sDEVICE=pdfwrite										
**---(That's device being used)**
  
  -dPDFSETTINGS=/ebook								
**---(Quality of 150 dpi per file)**
  
  -dCompressFonts=true								
**---(Making sure fonts are visually the same)**
  
  -dEmbedAllFonts=true
  
  -dSubsetFonts=true
  
  -dAutoRotatePages=/None
  
  -dDownsampleColorImages=true				
**---(Setting compression on images)**
  
  -dDownsampleGrayImages=true					
**---(Setting compression on images)**
  
  -dColorImageDownsampleThreshold=1.0	
**---(It means the images are beign recreated at 108 dpi)**
  
  -dGrayImageDownsampleThreshold=1.0	
**---(It means the images are beign recreated at 108 dpi)**
  
  -dMonoImageDownsampleThreshold=1.0	
**---(It means the images are beign recreated at 108 dpi)**
  
  -dNOGC															
**---(Turning of garbage colector**
  
  -dNumRenderingThreads=8							
**---(Number of CPU's being used to multithread operations)**

## Retrictions:

*** To instances of the application can't create or use the same file.**
	
*** Your application/console/user has to have access to the origin/destination folder**

*** Sometimes compression create a Output file larger then Input file. That's because of the quantity and quality of images within the file. We can't control or ensure that the image inside is already the smaller one possible.**

## Recommendations:
	
**You should create Hash names for your files, and copy to a temp folder before executing compression. That way you ensure no one else is using the same file, and your application has acess to the origin/destination folder.**

**If you are using this in large scale, you need to delete your temp files after compression and maybe the logs after a while.**

**If you are embeddeding this application inside your on application, make sure to call it HIDE/QUITE on shell.**



##### You can call it as manny times as you need, using like multithread

**Original File compressed in one file**
![originalFileToCompressed](/prints/originalFileToCompressed.png)


**Original File being compressed in manny files**
![originalFileToManny](/prints/originalFileToManny.png)