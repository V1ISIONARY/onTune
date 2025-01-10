// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class Playlist extends StatefulWidget {

  final String artistName;

  const Playlist({
    super.key,
    required this.artistName
  });

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
    );
  }
}