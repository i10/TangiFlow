# TangiFlow

## Table of Contents  
* [What is TangiFlow?](#description)
* [Available Functionalities](#available)  
* [Installation](#installation)  
* [Extending TangiFlow](#custom)
<a name="description"/>

## What is TangiFlow?
TangiFlow is a tangible-based implementation of visual flow-based programming. 
It allows general-purpose programming via Python on a Microsoft Surface Hub. 
Users can use predefined nodes to specify data flow programs. 
TangiFlow is written in Swift and Python; Swift is responsible for front-end and Python is responsible for the backend of our system. 
To detect touch events we use MultiTouchKit (MTK), a Swift-based framework that handles touch events. 

### Toolbars
Shown below is the TangiFlow interface. 
The two toolbars on the sides of the screen contain all available functions:
![Workspace](https://github.com/i10/TangiFlow/blob/master/ReadMe%20Images/workspace21.jpg)

Here is a toolbar zoomed in:

<img src="https://github.com/i10/TangiFlow/blob/master/ReadMe%20Images/submenu1.png" alt="" height="500">

### Nodes
Once the user selects an item from the toolbar, the corresponding functionality will appear as a node on workspace as shown below.
Each node can have input and output fields and buttons to facilitate actions.

#### Source Nodes
Unlike other nodes, data source nodes do not take input from other nodes; instead, the folder button on the data source node can be used to select data source. 

<img src="https://github.com/i10/TangiFlow/blob/master/ReadMe%20Images/samplesourcenode.jpg" alt="" height="300">

<img src="https://github.com/i10/TangiFlow/blob/master/ReadMe%20Images/manager.jpg" alt="" height="300">

### Branching the Output
Branch button increases amount of output arcs branching output of the node. 
New arcs will deliver the same data as other output arcs of the node.

<img src="https://github.com/i10/TangiFlow/blob/master/ReadMe%20Images/branching.jpg" alt="" height="300">

### Processing Nodes
<img src="https://github.com/i10/TangiFlow/blob/master/ReadMe%20Images/sampletermnode.jpg" alt="" height="300">

Processing nodes as the name implies process the input data. 
They can have some extra input as textual data and those inputs can be provided either via keyboard or slider.

<img src="https://github.com/i10/TangiFlow/blob/master/ReadMe%20Images/slider.jpg" alt="" height="300">
<img src="https://github.com/i10/TangiFlow/blob/master/ReadMe%20Images/keyboard.png" alt="" height="300">

<a name="available"/>

## Available Functionalities

Users can use the following predefined functionalities to edit image files:
  * Select image
  * Change contrast
  * Change brightness
  * Change saturation
  * Change sharpness
  * Transform to black and white
  * Apply filters (LoFi, Gingham, Inkwell, Valencia, and Kelvin)
  * Stitch images (horizontal and vertical)
  * Add caption

Users can also create their own functions using Python; see [Extending Tangiflow](#custom)

<a name="installation"/>

## Installation

This git repository consists of two parts: Python back-end and Swift front-end. 
To run TangiFlow on a computer with macOS, a virtual machine that can run Windows, MTK, and a Microsoft Surface Hub are needed. 
Windows virtual machine runs an in-house software that sends touch events from the Surface Hub to the MTK. 
More information about MTK can be found in [Rene Linden's thesis](https://hci.rwth-aachen.de/publications/linden2015a.pdf). 
*FileHandler.swift* file contains the paths to folders and files that TangiFlow uses. 

```swift
var projectDataPath =  "/Users/ppi/Documents/Code/MasterAsifPythonBackEnd/Files/myproj.json"
var graphDataPath = "/Users/ppi/Documents/Code/MasterAsifPythonBackEnd/Files/graph.json"    
var resultFolderPath = "/Users/ppi/Documents/Code/MasterAsifPythonBackEnd/Files/Result"
var imagesFolderPath = "/Users/ppi/Documents/Code/MasterAsifPythonBackEnd/Files/Images"    
var mainScriptpath = "/Users/ppi/Documents/Code/MasterAsifPythonBackEnd/main.py"
var copyProj = "/Users/ppi/Documents/Code/MasterAsifPythonBackEnd/Files/copy_proj.json"
var imageSource = "/Users/ppi/Desktop/ImageSource"
 ```

_/Users/ppi/Documents/Code/MasterAsifPythonBackEnd/_ is the path where our back-end is installed. 
You can change this part of paths to the location of python back-end on your machine.
After installing the back-end and front-end, make sure to install dependencies. 
For the front-end you can use _Carthage_  to install SwiftyJSON. 
This is the only dependency we are using (_Carthage_ is dependency manager for Swift projects. 
You can check how to install dependencies from official [repository]((https://github.com/Carthage/Carthage))).  For the back-end you will need to install next libraries using _PIP_ (PIP is a package installer for python. You can learn how to install packages using pip from official [site](https://pypi.org/project/pip/)):
  * pythonflow
  * cv2
  * pilgram
  * pil
  * numpy
  * textwrap
  
After all these dependencies are installed the software is ready to run on our setup. Simply open file _MasterAsif2.workspace_ in XCode and run the project. 
Note: please make sure to checkout TangiFlow_Version branch from MTK repository and build that version of MTK. If you encounter error like one on the next screenshot just go to the path which stands after _Referenced from_ and copy paste the MTK inside the Frameworks folder. 

![errorscreen](https://github.com/i10/TangiFlow/blob/master/ReadMe%20Images/mtkerror.PNG)




<a name="custom"/>

## Extending TangiFlow

Developers can create their own functions. 
Currently, TangiFlow only supports generic Python data structures and images. 
Developers can add support for audio, video and other data types in future.
All functions are stored in back-end location in the file _Subroutines.py_. 
A sample of this file:

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

Each function represent a node. 
There two types of nodes: source nodes and processing nodes. 
Source nodes provide data, processing nodes process provided data. 
_Subroutines.py_ file must always import pythonflow and BackToSwift modules. 
After importing those modules you can import any other module you need in your project. 
Every function must have decorator _@pf.opmethod(length=1)_. 
All processing functions must have argument which represents recieved data, in our sample this argument called _image_ but you can name it as you want. 
If you want nodes in TangiFlow with controllable elements like text input, slider or file manager where you can pick file you need to add argument with _controled__ prefix. 
As it can be seen source nodes does not have input data so they don't have argument which represents data. Using source nodes users can get data and source of the data is represented by _controled_value_ argument. 
Later in this documentation I will explain how front-end detects and renders nodes based on arguments of functions. 
And at last all functions have _id_ argument which uniquely represents each node on the screen in order to generate output file for each of them.

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
