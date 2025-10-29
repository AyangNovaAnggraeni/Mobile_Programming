# project_uts


````markdown
# 🎮 Split or Steal — A Game Theory Mini Game

A simple yet engaging **Flutter app** inspired by the *Prisoner's Dilemma* and the TV game “Golden Balls.”  
This app lets you play the famous **Split or Steal** game against an AI opponent that can behave with different strategies — exploring how trust and greed affect outcomes.

---

## 🧩 Project Overview

In this game, both you and the AI decide between:
- 🤝 **Split** — cooperate and share the reward, or  
- 🗡️ **Steal** — betray and take it all.

The results depend on your combined decisions:

| Your Choice | AI Choice | You Gain | AI Gain |
|--------------|------------|-----------|----------|
| Split | Split | +2 | +2 |
| Split | Steal | +0 | +3 |
| Steal | Split | +3 | +0 |
| Steal | Steal | +0 | +0 |

---

## 🧠 Game Logic

This app demonstrates key principles from **Game Theory** — especially the **Prisoner’s Dilemma**:

- Cooperation (Split) benefits both if trust exists.  
- Betrayal (Steal) can yield more profit short-term, but mutual betrayal leads to zero gain.  
- The AI can follow several strategies:
  - 🌀 **Random** — unpredictable.
  - 💬 **Tit-for-Tat** — copies your previous move (forgives but remembers).
  - 💚 **Always Split** — the friendly type.
  - 🔪 **Always Steal** — the greedy one.

---

## ✨ Features

✅ Built with **Flutter** (no navigation).  
✅ Uses both **Stateless** and **Stateful Widgets**.  
✅ Includes **MaterialApp**, **Scaffold**, and **AppBar**.  
✅ Displays **Text**, **Row**, and **Column** widgets.  
✅ Loads **images** from both local assets and the internet.  
✅ Implements **dynamic UI** updates with `super.key`.  
✅ Has **score tracking**, **move history**, and **AI strategy selection**.  

---

## 🖼️ Screenshots

| Gameplay | Result Example | History |
|-----------|----------------|----------|
| ![Gameplay](https://cdn-icons-png.flaticon.com/512/1517/1517806.png) | ![Result](https://cdn-icons-png.flaticon.com/512/1517/1517806.png) | ![History](https://cdn-icons-png.flaticon.com/512/1517/1517806.png) |

*(You can replace the above with your real screenshots later)*

---

## 🧱 Tech Stack

- **Framework:** Flutter  
- **Language:** Dart  
- **IDE:** Android Studio / VS Code  
- **Dependencies:** None (pure Flutter)  

---

## 🚀 How to Run

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/split-or-steal.git
````

2. Open the project in your code editor.
3. Get Flutter dependencies:

   ```bash
   flutter pub get
   ```
4. Run it on an emulator or web:

   ```bash
   flutter run
   ```

---

## 🪙 Assets

* Local: `assets/images/coin.png`
* Fallback: [Flaticon Coin Icon](https://cdn-icons-png.flaticon.com/512/1517/1517806.png)

*(Make sure you declare your assets in `pubspec.yaml`)*

```yaml
flutter:
  assets:
    - assets/images/coin.png
```

---

## 💡 Future Ideas

* Multiplayer version (real-time choices between two devices).
* Improved UI animations.
* Leaderboard or score saving.
* Statistical analysis of strategies.

---

## 📘 Educational Purpose

This project is great for:

* Understanding **Game Theory concepts**.
* Practicing **Flutter UI and state management**.
* Demonstrating **dynamic UI behavior** in a simple project.

---

## 🧑‍💻 Author

**Ayang Nova Anggraeni**
📍 Indonesia
💬 Made with ❤️ for a university Flutter assignment.

---

## 🪞 License

This project is open-source under the **MIT License** — feel free to use or modify it for learning purposes.

---


