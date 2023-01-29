import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_example/model/monster.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hive Database Demo"),
      ),
      body: FutureBuilder(
        future: Hive.openBox("monsters"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                ),
              );
            } else {
              var monstersBox = Hive.box("monsters");

              if (monstersBox.length == 0) {
                monstersBox.add(Monster("vampire", 1));
                monstersBox.add(Monster("jelly guardian", 5));
              }

              return WatchBoxBuilder(
                box: monstersBox,
                builder: (context, monsters) => Container(
                  margin: const EdgeInsets.all(20),
                  child: ListView.builder(
                    itemCount: monsters.length,
                    itemBuilder: (context, index) {
                      Monster monster = monsters.getAt(index);
                      return Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(bottom: 10),
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: Offset(3, 3),
                              blurRadius: 6)
                        ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${monster.name} [${monster.level}]"),
                            Row(
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  shape: CircleBorder(),
                                  clipBehavior: Clip.hardEdge,
                                  child: IconButton(
                                    icon: Icon(Icons.trending_up),
                                    iconSize: 30,
                                    color: Colors.green,
                                    onPressed: () {
                                      monsters.putAt(
                                          index,
                                          Monster(
                                              monster.name, monster.level + 1));
                                    },
                                  ),
                                ),
                                RawMaterialButton(
                                  onPressed: () {
                                    monsters.add(
                                        Monster(monster.name, monster.level));
                                  },
                                  //do your action
                                  elevation: 0.0,
                                  constraints: BoxConstraints(),
                                  //removes empty spaces around of icon
                                  shape: CircleBorder(),
                                  //circular button
                                  fillColor: Colors.white,
                                  //background color
                                  splashColor: Colors.amber,
                                  highlightColor: Colors.amber,
                                  child: Icon(
                                    Icons.content_copy,
                                    color: Colors.amber,
                                  ),
                                  padding: EdgeInsets.all(8),
                                ),
                                RawMaterialButton(
                                  onPressed: () {
                                    monsters.deleteAt(index);
                                  },
                                  //do your action
                                  elevation: 0.0,
                                  constraints: BoxConstraints(),
                                  //removes empty spaces around of icon
                                  shape: CircleBorder(),
                                  //circular button
                                  fillColor: Colors.white,
                                  //background color
                                  splashColor: Colors.amber,
                                  highlightColor: Colors.amber,
                                  child: Icon(Icons.delete, color: Colors.red),
                                  padding: EdgeInsets.all(8),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
