import 'package:flutter/material.dart';

void main() => runApp(MyApp());

bool _isPlayer1 = true;
List<List<int>> _board = [[0, 0, 0], [0, 0, 0], [0, 0, 0]];
List<List<List<int>>> _winning_comb = [[[0,0],[0,1],[0,2]], [[0,0],[1,1],[2,2]], [[0,0],[1,0],[2,0]],
  [[1,0],[1,1],[1,2]], [[0,1],[1,1],[2,1]],[[0,2],[1,2], [2,2]],
  [[2,0],[2,1],[2,2]], [[2,0], [1,1], [0,2]]];
final ValueNotifier<String> _playerText = ValueNotifier<String>('Player 1 plays now!');

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.black,
              title: const Center(
                child: const Text('Tic Tac Toe'),
              )
          ),
          body: Board(),
        )
    );
  }
}

class Board extends StatefulWidget {
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            ValueListenableBuilder(
              builder: (BuildContext context, String text, Widget? child){
                return Text(
                  text,
                  style: const TextStyle(fontSize: 20),
                );
              },
              valueListenable: _playerText,
            ),
          const SizedBox(height: 30),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyRow(0),
                MyRow(1),
                MyRow(2),
              ]),
          const SizedBox(height: 30),
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.black,
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () {},
            child: const Text('Reset Board'),
          ),]
    );
  }
}

class MyRow extends StatelessWidget {
  int id;
  MyRow(this.id);
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WhiteBox(id, 0),
            WhiteBox(id, 1),
            WhiteBox(id, 2),
          ],
        )
    );
  }
}

class WhiteBox extends StatefulWidget {
  int row_id;
  int id;
  WhiteBox(this.row_id, this.id);
  @override
  _WhiteBoxState createState() => _WhiteBoxState(row_id, id);
}

class _WhiteBoxState extends State<WhiteBox> {
  int row_id;
  int id;
  _WhiteBoxState(this.row_id, this.id);
  bool _isNotOccupied = true;
  var _usedIcon = Icon(null);
  void _toggleIcon() {
    setState(() {
      print(_playerText);
      if (_isPlayer1 & _isNotOccupied){
        _isPlayer1 = false;
        _usedIcon = Icon(Icons.circle_outlined);
        _playerText.value = 'Player 2 plays now!';
        _isNotOccupied = false;
        _board[row_id][id] = 1;
      } else if (_isNotOccupied) {
        _isPlayer1 = true;
        _usedIcon = Icon(Icons.clear);
        _playerText.value = 'Player 1 plays now!';
        _isNotOccupied = false;
        _board[row_id][id] = -1;
      }
      checkWin();
    });
  }
  void checkWin(){
    for(List<List<int>> _comb in _winning_comb){
      int sum = 0;
      for(List<int> _elem in _comb){
        sum += _board[_elem[0]][_elem[1]];
      }
      if(sum == 3){
        _isNotOccupied = false;
        _playerText.value = 'Player1 won!';
      } else if(sum == -3){
        _isNotOccupied = false;
        _playerText.value = 'Player2 won!';
      }
    }}
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(),
        ),
        child: IconButton(
          padding: EdgeInsets.all(0),
          alignment: Alignment.center,
          icon: _usedIcon,
          onPressed: _toggleIcon,
        )
    );
  }
}