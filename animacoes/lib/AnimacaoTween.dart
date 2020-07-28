import 'package:flutter/material.dart';

class AnimacaoTween extends StatefulWidget {
  @override
  _AnimacaoTweenState createState() => _AnimacaoTweenState();
}

class _AnimacaoTweenState extends State<AnimacaoTween> {
  @override
  Widget build(BuildContext context) {
    return Center(
      // child: TweenAnimationBuilder(
      //   duration: Duration(seconds: 2),
      //   tween: Tween<double>(
      //     begin: 0,
      //     end: 6.28
      //   ),
      //   builder: (BuildContext context, double valor, Widget widget){
      //     return Transform.rotate(
      //             angle: valor,
      //             child: Image.asset("imagens/logo.png"),
      //           );
      //   },
      // ),

      // child: TweenAnimationBuilder(
      //   duration: Duration(seconds: 2),
      //   tween: Tween<double>(
      //     begin: 50,
      //     end: 180
      //   ),
      //   builder: (BuildContext context, double valor, Widget widget){
      //     return Container(
      //       color: Colors.green,
      //       width: valor,
      //       height: 60,
      //     );
      //   },
      // )

      child: TweenAnimationBuilder(
        duration: Duration(seconds: 2),
        tween: ColorTween(
          begin: Colors.white,
          end: Colors.orange
        ),
        builder: (BuildContext context, Color valor, Widget widget){
          return ColorFiltered(
            colorFilter: ColorFilter.mode(
              valor, BlendMode.overlay
            ),
            child: Image.asset("imagens/logo.png"),
          );
        },
      )
    );
  }
}