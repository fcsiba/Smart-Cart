import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';

class Redeem extends StatefulWidget {
  Redeem({Key key}) : super(key: key);

  @override
  _RedeemState createState() => _RedeemState();
}

class _RedeemState extends State<Redeem> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  BeautifulPopup popup;

  int _till = 540;// Random().nextInt(1000);

  @override
  void get initState {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5200),
    );
    _animation = _controller;
    super.initState;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    popup = BeautifulPopup(
      context: context,
      template: TemplateCoin,
    );

    setState(() {
      // _till += rng.nextInt(20) + 0.3;
      _animation = new Tween<double>(
        begin: _animation.value,
        end: _till + .0,
      ).animate(new CurvedAnimation(
        curve: Curves.fastOutSlowIn,
        parent: _controller,
      ));
    });
    _controller.forward(from: 0.0);

    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Image.asset(
            'assets/animations/plant-animation.gif',
          ),
          Text('Your efforts have earned...',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          new AnimatedBuilder(
            animation: _animation,
            builder: (BuildContext context, Widget child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  new Text(
                    _animation.value.toStringAsFixed(0),
                    style: TextStyle(fontSize: 52, fontWeight: FontWeight.bold),
                  ),
                  Text(" points",
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(Icons.info_outline, size: 18),
                    onPressed: () => showCompletedPopup(context),
                  )
                ],
              );
            },
          ),
          ActionChip(
            onPressed: () {},
            avatar: Icon(
              Icons.attach_money,
              color: Colors.white,
            ),
            label: Text("Redeem Prizes! Coming Soon!",
                style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.orangeAccent,
          )
        ],
      ),
    );
  }

  void showCompletedPopup(BuildContext context) {
    final newColor = Theme.of(context).primaryColor.withOpacity(0.8);
    popup.recolor(newColor);
    popup.show(
      title: 'Earn some coin!',
      content: Center(
        child: Text(
            "The more missions you complete, and engage witht the community, the more points you can redeem which can then be cashed in to win some awesome prizes!"),
      ),
      actions: [
        popup.button(
          label: 'Close',
          onPressed: Navigator.of(context).pop,
        ),
      ],
      // bool barrierDismissible = false,
      // Widget close,
    );
  }
}
