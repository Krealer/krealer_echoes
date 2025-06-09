# Krealer: Echoes of the Null

**Genre:** Tactical Turn-Based RPG with Psychological Dialogue
**Engine:** [LOVE2D](https://love2d.org/) (LÖVE)
**Language:** Lua
**Platform Target:** Homebrewed Nintendo Switch (`.nro`) and Nintendo 3DS (`.3dsx`)

---

## 🚀 Status: Work In Progress

> **Disclaimer:** This project is in active development and currently **very buggy**. It is not intended for stable play. Many core systems are in place but require polish, stability fixes, and optimization for handheld hardware.

---

## ⚖️ Concept

You play as **Krealer**, a cold, hyper-logical escapee from a militarized psychological facility known as **The Null Factor**. Trained in emotional suppression, strategic manipulation, and classical combat, Krealer now navigates an ordinary world, attempting to reclaim his humanity in a world that doesn’t understand him—and that he doesn’t understand either.

---

## 🌐 World & Setting

* The world is grounded and normal (not dystopian or cyberpunk).
* Most people are unaware of The Null Factor's existence.
* Krealer is feared, misunderstood, or hunted depending on who he meets.

---

## ⚔️ Gameplay Structure

* **Exploration:** Grid-based real-time movement (WASD/Arrow keys or D-Pad).
* **Interaction:** When next to an NPC, object, or enemy, pressing `Space`, `Enter`, or `Y` triggers dialogue, combat, or events.
* **Dialogue System:** Branching psychological conversations with manipulation, silence, or honesty-based outcomes.
* **Combat:** Turn-based tactical grid battles featuring HP/MP, skills, passives, and positioning.

---

## 🔧 Current Systems (Implemented)

* Map loading with tile logic
* Exploration state (player movement)
* Basic combat system (skills, turn order)
* Dynamic dialogue with branching trees
* Entity interaction (NPC, Enemy, Object proximity)
* Inventory system (pickup/use/remove)
* Gamepad support (Switch/3DS compatibility goal)

---

## 🔌 Platform-Specific Support

* Targeting **Nintendo Switch (homebrew)** with `.nro` output
* Targeting **Nintendo 3DS (homebrew)** with `.3dsx` output
* All systems built with **pure code only** (no external assets)

---

## 🌐 Goals

* Create a psychologically immersive tactical experience
* Build a fully navigable grid world with conditional events
* Maintain platform-agnostic logic that runs on handheld consoles

---

## 🌍 License

Currently proprietary and for internal development/testing use only.

---

## ✍️ Note from the Developer

This project is both a technical challenge and a passion project. Krealer’s story is rooted in trauma, control, and calculated survival. The game itself reflects that: minimalist, strategic, and unforgiving.

If you're reading this and you're a dev interested in handheld Lua development or psychological narrative mechanics, feel free to watch this space.

---

## ⚠️ Known Issues

* Combat outcomes don’t always resolve properly
* Dialogue trees may break if malformed
* Fullscreen toggle not centered on all resolutions
* NPC/Entity overlap behavior needs refining

---

Stay sharp.

— The Null doesn't forget.
