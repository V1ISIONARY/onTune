// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ontune/frontend/widget/secret/music_section_player.dart';
import 'package:ontune/resources/schema.dart';
import '../../backend/bloc/on_tune_bloc.dart';
import '../../backend/services/model/artist.dart';
import '../../backend/services/model/classification.dart';
import '../../backend/services/model/randomized.dart';
import '../widget/audio_controller.dart';
import '../widget/designs/fade.dart';
import '../widget/designs/seeMore.dart';
import '../widget/designs/textLimit.dart';
import '../widget/secret/album_section.dart';
import '../widget/secret/more_music_like.dart';

class Player extends StatefulWidget {

  final Color textColor;
  final VoidCallback onClose;
  final Color backgroundColor;
  final String writer;
  final String youtubeUrl;
  final String thumbnail;
  final String title;

  const Player({
    Key? key,
    required this.title,
    required this.writer,
    required this.youtubeUrl,
    required this.thumbnail,
    required this.backgroundColor,
    required this.textColor,
    required this.onClose,
  }) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> with TickerProviderStateMixin {
  final AudioController _audioController = AudioController();
  late AnimationController _animationController;
  late Animation<Offset> _scrollAnimation;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double frontContainerHeight = 450;
  bool isLyricsVisible = false;
  bool _isPlaying = false;
  String musicTitle = 'Unknown Title';
  double _opacity = 0.0;
  String writer = 'Unknown Artist';
  String description = 'Unknown Description';
  String lyrics = 'No lyrics available';
  FetchedAudio? fetchedAudio;
  FetchedArtist? fetchedArtist;

  void toggleHeight() {
    setState(() {
      frontContainerHeight = frontContainerHeight == 450 ? 415 : 450;
    });
  }

  @override
  void initState() {
    super.initState();
    
    context.read<OnTuneBloc>().add(FindLyrics(musicTitle.toString(), writer.toString()));

    _audioController.audioPlayer.playerStateStream.listen((state) {
      setState(() => _isPlaying = state.playing);
      print("Player state changed: ${state.playing ? 'playing' : 'paused'}");
    });

    _audioController.audioPlayer.durationStream.listen((d) {
      setState(() => _duration = d ?? Duration.zero);
    });

    _audioController.audioPlayer.positionStream.listen((p) {
      setState(() => _position = p);
    });

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat();

    _scrollAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));

    _startFadeOut();
    context.read<OnTuneBloc>().add(FindArtist(widget.writer));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<OnTuneBloc>().add(FindAudio(widget.youtubeUrl));
  }

  void _startFadeOut() {
    Future.delayed(Duration(seconds: 3), () {
      Timer.periodic(Duration(milliseconds: 100), (timer) {
        if (_opacity >= 1.0) {
          timer.cancel();
        } else {
          setState(() {
            _opacity += 0.1;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _audioController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary_color,
      body: BlocConsumer<OnTuneBloc, OnTuneState>(
        listener: (context, state) {
          if (state is FetchedAudio) {
            _audioController.audioPlayer.setUrl(state.audioUrl).then((_) {
              print("Audio source set, attempting to play");
              _audioController.audioPlayer.play().then((_) {
                print("Play command issued");
              }).catchError((error) {
                print("Error playing audio: $error");
              });
            }).catchError((error) {
              print("Error setting audio source: $error");
            });
          }
        },
        builder: (context, state) {
          if (state is LoadingTune) {
            return const Center(child: CircularProgressIndicator());
          } 
          else if (state is FetchedArtist) {
            fetchedArtist = state; 
            writer = fetchedArtist!.artist; 
            description = fetchedArtist!.description;
          } 
          else if (state is FetchedAudio) {
            fetchedAudio = state;
            musicTitle = fetchedAudio!.musicTitle.isNotEmpty ? fetchedAudio!.musicTitle : musicTitle;
            lyrics = fetchedAudio!.lyrics.isNotEmpty ? fetchedAudio!.lyrics : lyrics;
          } 
          else if (state is ErrorTune) {
            musicTitle = "Unknown Title";
            lyrics = "Lyrics not found";
            writer = "Unknown Artist";
          }

          return _buildPlayerUI(context);
        }
      )
    );
  }

  Widget _buildPlayerUI(BuildContext context) {

    List<Randomized> randomdemoSongs = [
      Randomized(
        musicTitle: "Song One",
        musicWriter: "Artist A",
        audioUrl: "https://example.com/song1.mp3",
        thumnail: "assets/images/song1.jpg",
        playlistUrl: "https://example.com/playlist1",
        subscribers: "1.2M",
        writerLogo: "assets/images/artistA_logo.png",
      ),
      Randomized(
        musicTitle: "Song Two",
        musicWriter: "Artist B",
        audioUrl: "https://example.com/song2.mp3",
        thumnail: "assets/images/song2.jpg",
        playlistUrl: "https://example.com/playlist2",
        subscribers: "980K",
        writerLogo: "assets/images/artistB_logo.png",
      ),
      Randomized(
        musicTitle: "Song Three",
        musicWriter: "Artist C",
        audioUrl: "https://example.com/song3.mp3",
        thumnail: "assets/images/song3.jpg",
        playlistUrl: "https://example.com/playlist3",
        subscribers: "2.5M",
        writerLogo: "assets/images/artistC_logo.png",
      ),
      Randomized(
        musicTitle: "Song Four",
        musicWriter: "Artist D",
        audioUrl: "https://example.com/song4.mp3",
        thumnail: "assets/images/song4.jpg",
        playlistUrl: "https://example.com/playlist4",
        subscribers: "750K",
        writerLogo: "assets/images/artistD_logo.png",
      ),
      Randomized(
        musicTitle: "Song Five",
        musicWriter: "Artist E",
        audioUrl: "https://example.com/song5.mp3",
        thumnail: "assets/images/song5.jpg",
        playlistUrl: "https://example.com/playlist5",
        subscribers: "3.1M",
        writerLogo: "assets/images/artistE_logo.png",
      ),
    ];


    List<Classification> demoSongs = [
      Classification(
        musicTitle: "Shape of You",
        musicWriter: "Ed Sheeran",
        audioUrl: "https://example.com/shape_of_you.mp3",
        lyrics: "The club isn't the best place to find a lover...",
      ),
      Classification(
        musicTitle: "Blinding Lights",
        musicWriter: "The Weeknd",
        audioUrl: "https://example.com/blinding_lights.mp3",
        lyrics: "I've been tryna call, I've been on my own for long enough...",
      ),
      Classification(
        musicTitle: "Levitating",
        musicWriter: "Dua Lipa",
        audioUrl: "https://example.com/levitating.mp3",
        lyrics: "If you wanna run away with me, I know a galaxy...",
      ),
      Classification(
        musicTitle: "Someone Like You",
        musicWriter: "Adele",
        audioUrl: "https://example.com/someone_like_you.mp3",
        lyrics: "I heard that you're settled down, that you found a girl...",
      ),
      Classification(
        musicTitle: "Senorita",
        musicWriter: "Shawn Mendes & Camila Cabello",
        audioUrl: "https://example.com/senorita.mp3",
        lyrics: "I love it when you call me Senorita...",
      ),
      Classification(
        musicTitle: "Stay",
        musicWriter: "The Kid LAROI & Justin Bieber",
        audioUrl: "https://example.com/stay.mp3",
        lyrics: "I do the same thing I told you that I never would...",
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Image.network(
                          // 'https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExN2J2bDRzZmNraDJ4cHA3NHlmY24xd3JzcWJjNWdmOWduemJyYmxnZiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/dYdEHJKB52aFB7k3bE/giphy.webp',
                          widget.thumbnail,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(color: Colors.grey);
                          },
                        ),
                      ),
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(
                            color: Colors.white.withOpacity(0.2),
                          )
                        ),
                      ),
                    ],
                  ),
                ),
                CustomPaint(
                  painter: WhiteBackgroundPainter(height: 0.6, begin: Alignment.topLeft, end: Alignment.bottomRight),
                  child: Container(),
                ),
                AppBar(
                  backgroundColor: Colors.transparent,
                  leading: GestureDetector(
                    onTap: (){
                      widget.onClose();
                    },
                    child: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white),
                  ),
                  title: const Text(
                    'Recommended for you',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                  centerTitle: true,
                  // actions: [
                  //   Padding(
                  //     padding: EdgeInsets.only(right: 10),
                  //     child: GestureDetector(
                  //       onTap: () {},
                  //       child: const Icon(Icons.more_horiz, color: Colors.white),
                  //     ),
                  //   )
                  // ],
                ),
                Container(
                  child: Column(
                    children: [
                      SizedBox(height: 110),
                      InkWell(
                        onTap: (){
                          toggleHeight();
                        },
                        child: Container(
                          height: 450, // Fixed height for the container
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 40),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)
                                  ), // Match container's border radius
                                  child: Container(
                                    color: Colors.black.withOpacity(0.7),
                                    padding: EdgeInsets.all(10),
                                    child: SingleChildScrollView(
                                      child: Text(
                                        limitText(lyrics.isNotEmpty ? lyrics : 'No available lyrics', 20),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10), // Match container's border radius
                                child: Stack(
                                  fit: StackFit.expand, // Ensure the image and text fill the available space
                                  children: [
                                    // Front Layer: Image (Dynamic height)
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      child: Stack(
                                        children: [
                                          AnimatedContainer(
                                            duration: Duration(milliseconds: 300), // Smooth height transition
                                            height: frontContainerHeight, // Dynamic height for the front image
                                            child: Container(
                                              color: Colors.black,
                                              width: double.infinity,
                                              child: Image.network(
                                                widget.thumbnail,
                                                fit: BoxFit.cover, // Ensures the image covers the area
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Container(
                                                    color: Colors.grey, // Default if image fails to load
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                      Icons.error,
                                                      color: Colors.white,
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          ),
                                          Positioned(  // Icon button to toggle visibility of the lyrics section
                                            bottom: 10,
                                            right: 10,
                                            child: IconButton(
                                              icon: Icon(Icons.lyrics_outlined),  // Correctly pass the icon to the icon property
                                              iconSize: 20,  // Set the size of the icon
                                              color: Colors.white,  // Set the icon color
                                              onPressed: toggleHeight,  // Call toggleHeight on icon press
                                            ),
                                          ),
                                        ]
                                      )
                                    ),
                                  ],
                                ),
                              ),
                            ]
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 60,
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 20,
                                    left: 20,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 200,  
                                          height: 25,  
                                          child: ClipRect(  
                                            child: musicTitle.length < 30  
                                              ? 
                                              SingleChildScrollView(  
                                                  scrollDirection: Axis.horizontal,
                                                  child: Text(
                                                    musicTitle.isNotEmpty ? widget.title : 'Title',
                                                    style: TextStyle(fontSize: 15, color: widget.textColor),
                                                    textAlign: TextAlign.start,  
                                                  ),
                                                )
                                              : 
                                              SlideTransition(
                                                  position: _scrollAnimation,  
                                                  child: SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,  
                                                    child: Text(
                                                      musicTitle.isNotEmpty ? widget.title : 'Title',
                                                      style: TextStyle(fontSize: 15, color: widget.textColor),
                                                      textAlign: TextAlign.start, 
                                                    ),
                                                  ),
                                                ),
                                          ),
                                        ),
                                        Text(
                                          limitText(writer.isNotEmpty ? widget.writer : 'Comperser', 20),
                                          style: TextStyle(fontSize: 10, color: secondary_color),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )
                                  ),
                                  // Positioned(
                                  //   top: 20,
                                  //   right: 20,
                                  //   child: Container(
                                  //     height: 40,
                                  //     child: Row(
                                  //       children: [
                                  //         Center(
                                  //           child: Icon(
                                  //             size: 20,
                                  //             color: Colors.white,
                                  //             Icons.headset_rounded
                                  //           )
                                  //         ),
                                  //         SizedBox(width: 10),
                                  //         Center(
                                  //           child: Icon(
                                  //             size: 20,
                                  //             color: Colors.white,
                                  //             Icons.heart_broken
                                  //           )
                                  //         )
                                  //       ]
                                  //     ),
                                  //   )
                                  // )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0), 
                                  overlayShape: RoundSliderOverlayShape(overlayRadius: 0),  
                                ),
                                child: Slider(
                                  value: _position.inSeconds.toDouble(),
                                  min: 0,
                                  max: _duration.inSeconds.toDouble(),
                                  activeColor: Colors.white38,      
                                  inactiveColor: Colors.white24,    
                                  onChanged: (value) {
                                    final position = Duration(seconds: value.toInt());
                                    _audioController.audioPlayer.seek(position);
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${_audioController.formatDuration(_audioController.position)}", style: TextStyle(fontSize: 11, color: widget.textColor)),
                                  Text("${_audioController.formatDuration(_audioController.duration)}", style: TextStyle(fontSize: 11, color: widget.textColor)),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Padding(
                                //   padding: EdgeInsets.only(left: 20),
                                //   child: GestureDetector(
                                //     onTap: (){},
                                //     child: Icon(
                                //       Icons.crop_rounded,
                                //       color: widget.textColor,
                                //     ),
                                //   )
                                // ),
                                // Expanded(
                                //   child: GestureDetector(
                                //     onTap: (){},
                                //     child: Icon(
                                //       size: 30,
                                //       Icons.skip_previous,
                                //       color: widget.textColor,
                                //     ),
                                //   )
                                // ),
                                Expanded(
                                  child: Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle, 
                                      color: widget.textColor, 
                                    ),
                                    child: GestureDetector(
                                      onTap: (){
                                        _audioController.togglePlayPause();
                                      },
                                      child: Icon(
                                        size: 30,
                                        _isPlaying ? Icons.pause : Icons.play_arrow,
                                        color: Colors.black, 
                                      ),
                                    )
                                  ),
                                ),
                                // Expanded(
                                //   child: GestureDetector(
                                //     onTap: (){},
                                //     child:  Icon(
                                //       size: 30,
                                //       Icons.skip_next,
                                //       color: widget.textColor, 
                                //     ),
                                //   )
                                // ),
                                // Padding(
                                //   padding: EdgeInsets.only(right: 20),
                                //   child: GestureDetector(
                                //     onTap: (){},
                                //     child:  Icon(
                                //       Icons.loop_outlined,
                                //       color: widget.textColor, 
                                //     ),
                                //   )
                                // ),
                                // IconButton(
                                //   icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up, color: widget.textColor),
                                //   onPressed: _toggleMute,
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                    ]
                  )
                ),
                Positioned(
                  bottom: 0,  
                  left: 20,  
                  right: 20,  
                  child: Container(
                    width: double.infinity, 
                    height: 50, 
                    decoration: BoxDecoration(
                      color: widgetPricolor, 
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Information from ${writer}',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 400,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: widgetPricolor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5)
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: IntrinsicHeight(
                      child: Container(
                        width: double.infinity,
                        child: Image.network(
                          widget.thumbnail,
                          fit: BoxFit.cover, 
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.error,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  )
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 35,
                        color: Colors.transparent,
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    writer,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                    ),
                                  ),
                                  // Text(
                                  //   "6.6M monthly listeners",
                                  //   style: TextStyle(
                                  //     fontSize: 10,
                                  //     color: Colors.white54,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Container(
                          width: double.infinity,
                          child: LimitedText(
                            text:description,
                            limit: 300,
                            onSeeMore: () {
                            },
                          ),
                        )
                      )
                    ],
                  )
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            decoration: BoxDecoration(
              color: widgetPricolor,
              borderRadius: BorderRadius.circular(5)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lyrics',
                  style: TextStyle(fontSize: 13, color: Colors.white)
                ),
                SizedBox(height: 5),
                BlocBuilder<OnTuneBloc, OnTuneState>(
                  builder: (context, state) {
                    if (state is LoadingTune) {
                      return CircularProgressIndicator();
                    } else if (state is FetchedLyrics) {
                      return Text(state.lyrics, style: TextStyle(color: Colors.white));
                    } else if (state is ErrorTune) {
                      return Text("Error: ${state.response}", style: TextStyle(color: Colors.red));
                    }
                    return Text("No lyrics found", style: TextStyle(color: Colors.grey));
                  },
                ),
              ],
            )
          ),
          // MusicSectionPlayer(
          //   title: "Tredending Music",
          //   subtitle: "Latest Hits of ${writer}",
          //   songs: demoSongs, 
          // ),
          // MoreMusicLike(title: 'More Music like $writer', songs: randomdemoSongs),
          // AlbumSection(title: 'Artist Album', songs: randomdemoSongs),
          Container(
            height: 200,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'onTune',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white
                    ),
                  ),
                  Text(
                    'Hello World Negah',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                      color: Colors.white30
                    ),
                  )
                ],
              ),
            ),
          )
        ]
      )
    );
  }

}