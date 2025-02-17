## Air Traffic Control Game (name to be decided later)

This game is made for [Brackeys Game Jam 2025.1](https://itch.io/jam/brackeys-13). The theme for this jam is **_Nothing can go wrong..._**

The project is made using [Godot v4.3](https://godotengine.org/download/archive/4.3-stable/) game engine.

## Development

### Files structure

- res://
  - actors - Contains the scenes and associated scripts of instantiable nodes/prefabs;
  - managers - Contains scenes and associated scripts which are binding the actors to the game loop;
  - scenes - Contains scenes and associated scripts which are a compound of actors and managers;
  - types - Contains custom types which can be used on nodes instead of traditional (more generic) existing ones;
  - utils - Contains utilitary functions and constants;

### Database
Godot editor cannot read contents of json files. To check/edit json files use Visual Studio Code.

### How to use signal_bus

- Add a signal to signal_bus.gd
- Now you can emit new signal from any script

```
SignalBus.plane_entered_interception.emit()
```

- For the script we want to receive the signal, in the _\_ready()_ function connect the signal

```
SignalBus.plane_entered_interception.connect(_on_entered_interception)
```

This allows us to have full control of who emits a signal and who receives it.

## Roadmap

[Detailed initial prototype and future versions](https://docs.google.com/document/d/1ooqeN-Y4p5SL3QLTZQyF9B_gke1VSoM8NP5iK8-5YFM/edit?tab=t.0#heading=h.f5d4h6sxowhu)

![Initial Prototype](https://cdn.discordapp.com/attachments/484099898413678595/1341133319970226248/Untitled_Diagram.png?ex=67b4e33c&is=67b391bc&hm=0bfda606d0cc0fe87bb572edb9dd746baa437673ad58afaebdda19db9f0d1ae6&)
