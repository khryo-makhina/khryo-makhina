help me to create such a C# app? I would like to mark the videos and images with the time stamp found else use the file creation timestamp. 

Can you generate a WPF app where the logics is separated from the presentation layer (WPF) but not with the overkilling MVVM?
--
Nice, this is a perfect use case for a small, clean WPF tool with a thin UI and a reusable core.

I’ll give you:

Solution structure

Core library (logic)

WPF app (simple code‑behind, no heavy MVVM)

Image EXIF + fallback timestamp

Easy extension point for video metadata later
--
Solution structure:

MediaRenamer.sln
  MediaRenamer.Core        // .NET 8 class library
    Models/
    Services/
  MediaRenamer.Wpf         // .NET 8 WPF app
    App.xaml / App.xaml.cs
    MainWindow.xaml / MainWindow.xaml.cs
	
NuGet (Core):

MetadataExtractor (for EXIF)

Note: add reference from MediaRenamer.Wpf to MediaRenamer.Core, and add System.Windows.Forms reference for FolderBrowserDialog (or replace with a WPF file dialog if you prefer).

Where to plug in video metadata
Right now, videos just fall back to file timestamps. To extend:

Create VideoMetadataProvider implementing IMetadataProvider (using ffprobe to read creation_time).

Create CompositeMetadataProvider that tries image EXIF, then video metadata, then returns null.

Wire CompositeMetadataProvider into FileRenamer instead of ExifMetadataProvider.

If you want, next step we can focus only on video metadata via ffprobe and I’ll give you a small, robust implementation for that piece.