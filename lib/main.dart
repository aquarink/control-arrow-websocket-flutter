import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:video_player/video_player.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Momoka',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Momoka Games',
        channel: new IOWebSocketChannel.connect("ws://204.48.28.161:3000"),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.channel}) : super(key: key);

  final String title;
  final WebSocketChannel channel;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  VideoPlayerController _videoPlayerController;
  Future<void> _initializeVideoPlayerFuture;

  _dipencet(String cmd, TapDownDetails tapDownDetails) {
    print("++++++ Command " + cmd + " ++++++");
    widget.channel.sink.add(cmd);

    // print("--- STREAM ---");
    // widget.channel.stream.listen((onData) {
    //   print(onData);
    // });
  }

  // GESTURE
  _stopGerakan(TapUpDetails tapUpDetails) {
    print("++++++ Command STOP ++++++");
    widget.channel.sink.add('1234*5');

    // print("--- STREAM ---");
    // widget.channel.stream.listen((onData) {
    //   print(onData);
    // });
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.network(
      'http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4',
    );

    // Initielize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();

    // Use the controller to loop the video.
    _videoPlayerController.setLooping(true);

    _videoPlayerController.play();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 40.0),
              child: Center(
                  child: FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If the VideoPlayerController has finished initialization, use
                    // the data it provides to limit the aspect ratio of the video.
                    return AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      // Use the VideoPlayer widget to display the video.
                      child: VideoPlayer(_videoPlayerController),
                    );
                  } else {
                    // If the VideoPlayerController is still initializing, show a
                    // loading spinner.
                    return Center(child: CircularProgressIndicator());
                  }
                },
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                onTapDown: (TapDownDetails tapDownDetails) =>
                    _dipencet('1234*3', tapDownDetails),
                onTapUp: (TapUpDetails tapUpDetails) =>
                    _stopGerakan(tapUpDetails),
                child: Container(
                  color: Colors.blueAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(Icons.arrow_upward),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GestureDetector(
                    onTapDown: (TapDownDetails tapDownDetails) =>
                        _dipencet('1234*1', tapDownDetails),
                    onTapUp: (TapUpDetails tapUpDetails) =>
                        _stopGerakan(tapUpDetails),
                    child: Container(
                      color: Colors.redAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(Icons.arrow_back),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GestureDetector(
                    onTapDown: (TapDownDetails tapDownDetails) =>
                        _dipencet('1234*5', tapDownDetails),
                    onTapUp: (TapUpDetails tapUpDetails) =>
                        _stopGerakan(tapUpDetails),
                    child: Container(
                      color: Colors.green,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(Icons.thumb_up),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GestureDetector(
                    onTapDown: (TapDownDetails tapDownDetails) =>
                        _dipencet('1234*1', tapDownDetails),
                    onTapUp: (TapUpDetails tapUpDetails) =>
                        _stopGerakan(tapUpDetails),
                    child: Container(
                      color: Colors.orangeAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(Icons.arrow_forward),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                onTapDown: (TapDownDetails tapDownDetails) =>
                    _dipencet('1234*4', tapDownDetails),
                onTapUp: (TapUpDetails tapUpDetails) =>
                    _stopGerakan(tapUpDetails),
                child: Container(
                  color: Colors.yellowAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(Icons.arrow_downward),
                  ),
                ),
              ),
            ),
            Container(
              child: StreamBuilder(
                stream: widget.channel.stream,
                builder: (context, snapshot) {
                  return Text(snapshot.hasData ? '${snapshot.data}' : '');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
