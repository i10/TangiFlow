# TangiFlow

## Table of Contents  
[Description](#description)
[Available funcionality](#available)  
[Instalation](#instalation)  
[Adding custom functions](#custom)
<a name="description"/>
## Description
TangiFlow is a tangible-based implementation of visual flow-based programming. It allows general-purpose programming via Python on a Microsoft Surface Hub. Users can create graph structures and create data flow programs.
TangiFlow is written in Swift and Python. Swift is responsible for front-end and Python is responsible for the backend of our system. To detect touch events we use MultiTouchKit (MTK). It is Swift based framework to handle touch events on touch screen. 

This is the workspace of TangiFlow. You can see 2 toolbars which contains all available functions:
![Workspace](https://github.com/i10/TangiFlow/blob/master/ReadMe%20Images/workspace21.jpg)

This is the close-up of toolbar:


<img src="https://github.com/i10/TangiFlow/blob/master/ReadMe%20Images/submenu1.png" alt="" height="300">

Once selected item from toolbar will appear as a node on workspace. There can be different types of node. Nodes can have input and output arcs and some action buttons on them.

Source node:
<img src="https://github.com/i10/TangiFlow/blob/master/ReadMe%20Images/samplesourcenode.jpg" alt="" height="300">

Source nodes does not have input arcs since they are providing other nodes with data themselves. If user presses folder button it will open file manager from where they can pick images.

File manager:
<img src="https://github.com/i10/TangiFlow/blob/master/ReadMe%20Images/manager.jpg" alt="" height="300">

Branch button increases amount of output arcs branching output of the node. New arcs will deliver the same data as other output arcs of the node.

Branching output: 
<img src="https://github.com/i10/TangiFlow/blob/master/ReadMe%20Images/branching.jpg" alt="" height="300">

Processing node:
<img src="https://github.com/i10/TangiFlow/blob/master/ReadMe%20Images/sampletermnode.jpg" alt="" height="300">

Processing nodes as the name implies process the input data. They can have some extra input as textual data and those inputs can be provided either via keyboard or slider.

<img src="https://github.com/i10/TangiFlow/blob/master/ReadMe%20Images/slider.jpg" alt="" height="300">
<img src="https://github.com/i10/TangiFlow/blob/master/ReadMe%20Images/keyboard.png" alt="" height="300">


## Available funcionality

Users can use existing functionality and edit image files. 
Available functions:
  * Choose image
  * Change contrast
  * Change brightness
  * Change saturation
  * Change sharpness
  * Transform to black and white
  * Apply filters (LoFi, Gingham, Inkwell, Valencia, Kelvin, )
  * Stitch images (horizontaly and verticaly)
  * Add caption

Users can also create their own functions using python. Our software is open for extension. We will explaing it later in this documentation.
<a name="instalation"/>
## Instalation

Repository consists of 2 parts: Python back-end and Swift front-end. To run the software a computer with MacOS, virtual machine with Windows, MTK and Microsoft Surface Hub is needed. Windows virtual machine runs in-house software which sends touch events from Surface Hub to MTK. More about how MTK works can be found in [thesis](https://hci.rwth-aachen.de/publications/linden2015a.pdf) of Rene Linden. *FileHandler.swift* file contains paths to folders and files which front-end and back-end utilizes. 

```swift
var projectDataPath =  "/Users/ppi/Documents/Code/MasterAsifPythonBackEnd/Files/myproj.json"
var graphDataPath = "/Users/ppi/Documents/Code/MasterAsifPythonBackEnd/Files/graph.json"    
var resultFolderPath = "/Users/ppi/Documents/Code/MasterAsifPythonBackEnd/Files/Result"
var imagesFolderPath = "/Users/ppi/Documents/Code/MasterAsifPythonBackEnd/Files/Images"    
var mainScriptpath = "/Users/ppi/Documents/Code/MasterAsifPythonBackEnd/main.py"
var copyProj = "/Users/ppi/Documents/Code/MasterAsifPythonBackEnd/Files/copy_proj.json"
var imageSource = "/Users/ppi/Desktop/ImageSource"
 ```
_/Users/ppi/Documents/Code/MasterAsifPythonBackEnd/_ is the path where our back-end is installed. You can change this part of paths to the location of python back-end on your machine.
After installation of back-end and front-end make sure to install dependencies. For the front-end you can use _CocoaPods_  to install SwiftyJSON this is the only dependency we are using (_CocoaPods_ is dependency manager for Swift projects. You can check how to install dependencies from official [site]((https://cocoapods.org/))).  For the back-end you will need to install next libraries using _PIP_ (PIP is a package installer for python. You can learn how to install packages using pip from official [site](https://pypi.org/project/pip/)):
  * pythonflow
  * cv2
  * pilgram
  * pil
  * numpy
  * textwrap
  
After all these dependencies are installed the software is ready to run on our setup. Simply open file _MasterAsif2.workspace_ in XCode and run the project.
<a name="custom"/>
## Adding custom functions

As it was mentioned before our software is open for extensions. Users can create their own functions. So far we only support generic python data and image data. If desired developers can add support for audio, video and other types of data in the future.
All functions are stored in back-end location in the file _Subroutines.py_. A sample of this file can be seen here:



```python
import pythonflow as pf
from PythonToSwift.BackToSwift import BackToSwift
from PIL import ImageFilter,ImageEnhance,Image,ImageDraw,ImageFont
import numpy as np
import cv2 as cv
#
# next two routines are samples for image editing nodes
#
@pf.opmethod(length=1)
def image_source(controled_value,id):
    return Image.open(controled_value)


@pf.opmethod(length=1)
def change_contrast(image,controled_value,id):
    contrast = ImageEnhance.Contrast(image)
    result = contrast.enhance(float(controled_value))
    BackToSwift().prepare_data(type=ResultType.image.value,node_id=id, data=result,tool_type="pil",extension="jpg")
    return result
    
#
# next routine is sample for generic python data type routine
#
@pf.opmethod(length=1)
def do_something(data,id):
    #
    #do something with data
    #then assign it to result variable
    #
    result = ...
    BackToSwift().prepare_data(type=ResultType.generic_python.value,data=result)
    return result
```
Each function represent a node. There 2 types of nodes: source nodes and processing nodes. Source nodes provide data, processing nodes process provided data. _Subroutines.py_ file must always import pythonflow and BackToSwift modules. After importing those modules you can import any other module you need in your project. Every function must have decorator _@pf.opmethod(length=1)_. All processing functions must have argument which represents recieved data, in our sample this argument called _image_ but you can name it as you want. If you want nodes in TangiFlow with controllable elements like text input, slider or file manager where you can pick file you need to add argument with _controled__ prefix. As it can be seen source nodes does not have input data so they don't have argument which represents data. Using source nodes users can get data and source of the data is represented by _controled_value_ argument. Later in this documentation I will explain how front-end detects and renders nodes based on arguments of functions. And at last all functions have _id_ argument which uniquely represents each node on the screen in order to generate output file for each of them.

```python
import pythonflow as pf
from PythonToSwift.BackToSwift import BackToSwift
@pf.opmethod(length=1)
def image_source(controled_value,id):
    return Image.open(controled_value)


@pf.opmethod(length=1)
def change_contrast(image,controled_value,id):
    contrast = ImageEnhance.Contrast(image)
    result = contrast.enhance(float(controled_value))
    BackToSwift().prepare_data(type=ResultType.image.value,node_id=id, data=result,tool_type="pil",extension="jpg")
    return result
```

After creating _Subroutines.py_ file just run SourceFileParser.py file which will parse the routines file and will create a readable representation of functions for backend.

After this you also need to create two json files in back-end folder _copy_proj.json_ and _myproj.json_ with next content for image editing project:
```json
{"config" : {
    "type" : "image",
    "tool_type" : "pil"
  }}
```
And with next content for generic python data types project:

```json
{"config" : {
    "type" : "generic_python"
  }}
```
Locations of files was mentioned previously in this documentation.

In order to teach TangiFlow to use functions from _Subroutines.py_ file as nodes we need to provide some data. Open _myproj.json_ file. Nodes are represented as dictionary of json objects:
```json
{
"config" : {
    "type" : "generic_python"
  },
  "PT-127.99.8" : {
    "info" : {
      "text" : "Lorem Ipsum Lorem Ipsum Lorem Ipsum",
      "img" : "\/Users\/ppi\/Documents\/Code\/MasterAsifPythonBackEnd\/Samples\/valencia.jpg"
    },
    "group_id" : "Apply filters",
    "alias" : "Apply Valencia filter",
    "arguments" : {
      "controled_args" : {

      },
      "main_args" : {
        "image" : "Image input"
      }
    },
    "function" : "apply_valencia"
  }
  
  }
```

This is sample of processing node PT-127.99.8 is unique id of this node. You can use any id you want as long as they dont match with other nodes' ids. Nodes with similar functionalities can be gathered in groups. In TangiFlow items with the same group_id will be grouped under item in toolbar with the title group_id. You also need to provide alias for node, alias is the name which will appear in front-end above every node. Function is the name of function from _Subroutines.py_ which will handle action of respective node. Each function can have arguments. They have 2 types of arguments: main arguments and controled arguments. Main arguments represents input arcs of each node and they represent data input. Controled arguments are all other arguments which can be controled by user during interaction with TangiFlow. It can be text input, input with slider, selection of data (e.g. select image from file manager). As it was mentioned before all controled arguments must have _controled__ prefix. Main arguments are quite simple they have key and value as a simple string. Key represents name of argument in _Subroutines.py_ and value represents its alias in TangiFlow which will be displayed near input arc.
Controled arguments on the other hand can be more complex. Sample of node where function gets input argument from slider on the node:
```json
"PT-127.99.1" : {
    "alias" : "Change saturation",
    "arguments" : {
      "controled_args" : {
        "controled_value" : {
          "max" : "10",
          "step" : "0.1",
          "type" : "slider",
          "min" : "0",
          "default" : "0"
        }
      },
      "main_args" : {
        "image" : "Image input"
      }
    },
    "function" : "change_saturation",
    "group_id" : "Change image parameters"
  }
```
TangiFlow will interpret argument _controled_value_ of function _change_saturation_ from _Subroutines.py_ as a slider with minimum value of 0 and maximum value of 10, with step of the slider 0.1 and with default value 0. 

This the sample of node where argument of the function will be interpreted as button which opens file manager and user can pick image from file manager:

```json
"PT-127.99.01" : {
    "alias" : "Load image",
    "arguments" : {
      "main_args" : {

      },
      "controled_args" : {
        "controled_value" : {
          "type" : "button",
          "alias" : "Load image"
        }
      }
    },
    "function" : "image_source"
  }
 ```
 Once user chooses image from file manager path of this image is assigned to _controled_value_ argument of _image_source_ function in _Subroutines.py_ file.
 
 Next sample shows how users can create inputs for nodes:
  ```json
 "PT-127.99.11" : {
    "alias" : "Add caption to image",
    "arguments" : {
      "main_args" : {
        "image" : "Image input"
      },
      "controled_args" : {
        "controled_caption" : {
          "type" : "text",
          "alias" : "Type caption..."
        }
      }
    },
    "function" : "add_caption"
  }
   ```
   Users can specify two types of text fields: alphanumeric text field and just numeric. They can specify it in _type_ section. In our sample it has type _text_ but if users just want to use numeric input they canchange it to _number_. _Info_ section in node's json structure is for toolbar. Nodes can be chosen from toolbars. Each button which represents a node can have info button which will give useful information for users in form of images. Users just can add path to the image which they want to show as hint for users and when user will press info button this image will appear as a hint.