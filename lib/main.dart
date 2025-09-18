import 'package:flutter/material.dart';

void main() {
  runApp(MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text('Emoji App'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const EmojiHeader(),
                const SizedBox(height: 16),
                EmojiDropdown(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmojiHeader extends StatelessWidget {
  const EmojiHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.yellow[200],
      child: const Text('Create your own emoji!'),
    );
  }
}

class EmojiDropdown extends StatefulWidget {
  const EmojiDropdown({super.key});

  @override
  State<EmojiDropdown> createState() => _EmojiDropdownState();
}

//emotions dropdown selection
class _EmojiDropdownState extends State<EmojiDropdown> {
  final List<String> items = ['Smile', 'Sad', 'In Love'];
  String selected = 'Smile';

  //adding details for each emotion
  final Map<String, List<String>> detailOptions = {
    'Smile': ['Normal', 'Party Hat', 'Sunglasses'],
    'Sad': ['Normal', 'One Tear', 'Two Tears'],
    'In Love': ['Normal', 'Blushing'],
  };

  String detail = 'Normal';

  // keep detail or features if emotion changes
  void _resetDetailIfNeeded() {
    final opts = detailOptions[selected]!;
    if (!opts.contains(detail)) {
      detail = opts.first;
    }
  }

  //makes sure detail matches the selected emotion
  @override
  Widget build(BuildContext context) {
    _resetDetailIfNeeded();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton<String>(
          value: selected,
          items: items
              .map((v) => DropdownMenuItem(value: v, child: Text(v)))
              .toList(),
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              selected = value;
              _resetDetailIfNeeded();
            });
          },
        ),
        Text('Selected: $selected'),

        const SizedBox(height: 12),

        Row(
          children: [
            const Text('Details: '),
            DropdownButton<String>(
              value: detail,
              items: detailOptions[selected]!
                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                  .toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() => detail = v);
              },
            ),
          ],
        ),

        Center(
          child: CustomPaint(
            size: const Size(200, 200),
            painter: EmojiPainter(selected, detail),
          ),
        ),
      ],
    );
  }
}

class EmojiPainter extends CustomPainter {
  final String mode; // which emoji style to add
  final String detail; //which detail to add
  EmojiPainter(this.mode, this.detail);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width * 0.4;

    // draw and color face circle
    final facePaint = Paint()..color = Colors.yellow;
    canvas.drawCircle(center, r, facePaint);
    // draw and color eyes
    final eyePaint = Paint()..color = Colors.black;
    final leftEye = Offset(center.dx - 40, center.dy - 30);
    final rightEye = Offset(center.dx + 40, center.dy - 30);
    canvas.drawCircle(leftEye, 10, eyePaint);
    canvas.drawCircle(rightEye, 10, eyePaint);

    // mouth paint
    final mouthPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    if (mode == 'Smile') {
      // smile arc
      final rect = Rect.fromCircle(center: center, radius: 60);
      canvas.drawArc(rect, 0, 3.14, false, mouthPaint);

      //details for smile option
      if (detail == 'Party Hat') {
        _drawPartyHat(canvas, center, r + 5.00);
      } else if (detail == 'Sunglasses') {
        _drawSunglasses(canvas, leftEye, rightEye);
      }
    } else if (mode == 'Sad') {
      // frown arc

      final rect = Rect.fromCircle(center: center.translate(0, 40), radius: 60);
      canvas.drawArc(rect, 3.14, 3.14, false, mouthPaint);
      //details for sad option
      if (detail == 'One Tear' || detail == 'Two Tears') {
        final tear = Paint()..color = Colors.blue;
        canvas.drawCircle(leftEye + const Offset(0, 22), 10, tear);
        if (detail == 'Two Tears') {
          canvas.drawCircle(rightEye + const Offset(0, 22), 10, tear);
        }
      }
    } else if (mode == 'In Love') {
      // heart eyes
      final heartPaint = Paint()..color = Colors.red;
      final leftHeartCenter = Offset(center.dx - 40, center.dy - 20);
      final rightHeartCenter = Offset(center.dx + 40, center.dy - 20);

      canvas.drawPath(_heartPath(leftHeartCenter, 25), heartPaint);
      canvas.drawPath(_heartPath(rightHeartCenter, 25), heartPaint);
      // smiling mouth
      final rect = Rect.fromCircle(center: center, radius: 60);
      canvas.drawArc(rect, 0, 3.14, false, mouthPaint);

      //details for in love option
      if (detail == 'Blushing') {
        final blush = Paint()..color = Colors.pinkAccent.withOpacity(0.6);
        canvas.drawCircle(leftEye + const Offset(-16, 25), 12, blush);
        canvas.drawCircle(rightEye + const Offset(16, 25), 12, blush);
      }
    }
  }

  //helpers

  // smile details, starting off with party hat
  void _drawPartyHat(Canvas canvas, Offset center, double r) {
    final hatPath = Path()
      ..moveTo(center.dx, center.dy - r * 2.00) //top
      ..lineTo(center.dx - r * 1.00, center.dy - r * 0.50) //bottom left
      ..lineTo(center.dx + r * 1.00, center.dy - r * 0.50) //bottom right
      ..close();

    final hatRect = Rect.fromLTWH(
      center.dx - r, //left
      center.dy - r * 3.00, //top
      r * 2, //width
      r * 1.5, // height
    );

    final hatPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Colors.orange, Colors.pink, Colors.red],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(hatRect);

    canvas.drawPath(hatPath, hatPaint);

    // hat pompom :D
    canvas.drawCircle(
      Offset(center.dx, center.dy - r * 2.00),
      r * 0.15,
      Paint()..color = Colors.white,
    );
  }

  void _drawSunglasses(Canvas canvas, Offset leftEye, Offset rightEye) {
    final lensPaint = Paint()..color = Colors.black;
    final bridgePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    //draw lenses
    canvas.drawRect(
      Rect.fromCenter(center: leftEye, width: 50, height: 36),
      lensPaint,
    );
    canvas.drawRect(
      Rect.fromCenter(center: rightEye, width: 50, height: 36),
      lensPaint,
    );

    //bridge
    canvas.drawLine(
      leftEye + const Offset(12, 0),
      rightEye + const Offset(-13, 0),
      bridgePaint,
    );
  }

  Path _heartPath(Offset c, double s) {
    final p = Path();

    p.moveTo(c.dx, c.dy + 0.40 * s);

    p.cubicTo(
      c.dx - 2.50 * s,
      c.dy - 2.50 * s,
      c.dx - 0.50 * s,
      c.dy - 2.00 * s,
      c.dx,
      c.dy - 1.00 * s,
    );

    p.cubicTo(
      c.dx + 3.00 * s,
      c.dy - 2.75 * s,
      c.dx + 1.00 * s,
      c.dy - 0.10 * s,
      c.dx,
      c.dy + 0.40 * s,
    );

    p.close();
    return p;
  }

  @override
  bool shouldRepaint(covariant EmojiPainter old) =>
      old.mode != mode || old.detail != detail;
}
