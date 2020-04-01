import 'dart:math';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:shadowlazer/components/Enemy.dart';
import 'package:shadowlazer/components/Player.dart';
import 'package:shadowlazer/components/enemy_spawner.dart';
import 'package:shadowlazer/components/health_bar.dart';
import 'package:shadowlazer/components/start_text.dart';
import 'package:shadowlazer/status.dart';
import 'package:shadowlazer/components/score_text.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/highscore_text.dart';

class GameController extends Game{
  final SharedPreferences storage;
  Random rand;
  Size screenSize;
  double titleSize;
  Player player;
  EnemySpawner enemySpawner;
  List<Enemy> enemies;
  HealthBar healthBar;
  int score;
  ScoreText scoreText;
  Status status;
  HighScoreText highscoreText;
  StartText startText;


    GameController(this.storage)
    {
      initialize();
    }
    void initialize() async
    {
      resize(await Flame.util.initialDimensions());
      status = Status.menu;
      rand = Random();
      player = Player(this);
      enemies = List<Enemy>();
      enemySpawner = EnemySpawner(this);
      healthBar = HealthBar(this);
      score = 0;
      scoreText = ScoreText(this);
      highscoreText = HighScoreText(this);
      startText = StartText(this);
    }
    void render(Canvas c)
    {
      Rect background = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
      Paint backgroundPaint = Paint()..color = Color(0xFFFAFAFA);
      c.drawRect(background, backgroundPaint);

      player.render(c);

      if(status == Status.menu)
        {
          startText.render(c);
          highscoreText.render(c);
        }
      else if(status == Status.playing)
        {

        }
      enemies.forEach((Enemy enemy) => enemy.render(c));
      scoreText.render(c);
      healthBar.render(c);
    }
    void update(double t)
    {
      if(status == Status.menu)
      {
        startText.update(t);
        highscoreText.update(t);
      }
      else if(status == Status.playing)
      {
        enemySpawner.update(t);
        enemies.forEach((Enemy enemy) => enemy.update(t));
        enemies.removeWhere((Enemy enemy) => enemy.isDead);
        player.update(t);
        scoreText.update(t);
        healthBar.update(t);
      }

    }
    void resize(Size size)
    {
      screenSize = size;
      titleSize = screenSize.width / 10;
    }
    void onTapDown(TapDownDetails d)
    {
      if(status == Status.menu)
        {
          status = Status.playing;
        }
      else if(status == Status.playing)
        {
          enemies.forEach((Enemy enemy)
          {
            if(enemy.enemyRect.contains(d.globalPosition))
            {
              enemy.onTapDown();
            }
          });
        }

    }

    void spawnEnemy()
    {
      double x,y;
      switch(rand.nextInt(4))
      {
        case 0:
          //top
          x = rand.nextDouble() * screenSize.width;
          y = -titleSize * 2.5;
          break;
        case 1:
          //right
          x = screenSize.width + titleSize * 2.5;
          y = rand.nextDouble() * screenSize.height;
          break;
        case 2:
          //bottom
          x = rand.nextDouble() * screenSize.width;
          y = screenSize.height + titleSize * 2.5;
          break;
        case 3:
          x = -titleSize * 2.5;
          y = rand.nextDouble() * screenSize.height;
          //left
          break;
      }
      enemies.add(Enemy(this, x, y));
    }
}