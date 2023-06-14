# Lemon Progression

## Object Recognition

#### Concept.

1. Pass the image through object detection.
2. If an object is detected in the image, crop it and pass to object classification.
3. Object classification only has two outputs, upright and upside down. Output what it thinks is the most likely.

#### Object detection.

https://developer.apple.com/documentation/createml/building-an-object-detector-data-source

https://developer.apple.com/videos/play/tech-talks/10155/

```json
[
{
  "imagefilename": "breakfast_0.png",
  "annotation": [
    {
      "coordinates": {
        "y": 156.062,
        "x": 195.122,
        "height": 148.872,
        "width": 148.03
      },
      "label": "Waffle"
    }
  ]
},
{
  "imagefilename": "breakfast_1.png",
  "annotation": [
    {
      "coordinates": {
        "y": 98.9209,
        "x": 128.744,
        "height": 151.798,
        "width": 153.056
      },
      "label": "Waffle"
    },
    {
      "coordinates": {
        "y": 182.254,
        "x": 256.172,
        "height": 159.712,
        "width": 208.147
      },
      "label": "Croissant"
    }
  ]
},
{
  "imagefilename": "breakfast_2.png",
  "annotation": [
    {
      "coordinates": {
        "y": 116.875,
        "x": 354.375,
        "height": 98.7501,
        "width": 85
      },
      "label": "Croissant"
    }
  ]
},
{
  "imagefilename": "breakfast_3.png",
  "annotation": [
    {
      "coordinates": {
        "y": 149.75,
        "x": 182.114,
        "height": 76.3134,
        "width": 101.063
      },
      "label": "Croissant"
    }
  ]
}
]
```

| Name     | Type   | Value                                                        |
| :------- | :----- | :----------------------------------------------------------- |
| `x`      | Number | The `x`-coordinate of the annotation’s anchor location with respect to the image origin, which `MLBoundingBoxCoordinatesOrigin` defines. |
| `y`      | Number | The `y`-coordinate of the annotation’s anchor location with respect to the image origin, which `MLBoundingBoxCoordinatesOrigin` defines. |
| `width`  | Number | The width of the annotation’s bounding box.                  |
| `height` | Number | The height of the annotation’s bounding box.                 |

<img src="Assets/Screenshot 2023-06-14 at 9.50.49 am.png" alt="Screenshot 2023-06-14 at 9.50.49 am" style="zoom: 50%;" /> 

<img src="/Users/andrepham/Desktop/Repos/LemonApp/Docs/Assets/Screenshot 2023-06-14 at 9.52.47 am.png" alt="Screenshot 2023-06-14 at 9.52.47 am" style="zoom:50%;" /> 

![image-20230614095357393](/Users/andrepham/Library/Application Support/typora-user-images/image-20230614095357393.png) 

Training parameters:

* Algorithm
    * Full network
        * Use this when you have >200 samples per class
        * The real deal
    * Transfer learning
        * Good for limited data (still at least 80 samples per class)
        * More light weight
* Iterations
    * Basically use the default
* Batch size
    * Basically use the default, but bigger *is* better in this case
* Grid size
    * Choose a grid size that matches the aspect ratio of the input images and training images
    * Smaller grid size (less squares) means less processing power required but also less granularity - if there's two objects within a grid, only one can be output

I/U measure: this is the percentage overlay between the expected bounding box and the predicted bounding box.

Bounding box creation:

* https://github.com/heartexlabs/label-studio
* https://github.com/Cartucho/OpenLabeling

#### Object classification.



