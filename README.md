# FruneLight - Enhanced OSRS Client

**Author:** FruityPebbles  
**Status:** Foundation Complete - Ready for Development  

FruneLight combines the best OSRS automation frameworks with cutting-edge ML/AI capabilities.

## ✅ Current Status

### Successfully Compiled Dependencies:
- **melxin-runelite.jar** (51.5 MB) - OpenOSRS injection foundation
- **melxin-devious-client.jar** (54.1 MB) - Complete automation engine  
- **melxin-microbot.jar** (65.6 MB) - Anti-detection & utility framework

### 🏗️ Project Structure:
```
frunelight/
├── libs/                     # Compiled framework JARs
├── src/main/java/net/frunelight/  # FruneLight source code
├── dependencies/             # Source repositories for reference
├── build.gradle.kts         # Build configuration
└── README.md               # This file
```

## 🚀 Next Development Phase

### Phase 1: Rs2 API Framework (Week 1)
Create DreamBot-style static API using our compiled dependencies:

```java
// Target API Design
Rs2Npc.closest("Guard").interact("Attack");
Rs2Inventory.contains("Food");
Rs2Bank.depositAll();
```

### Phase 2: ML Integration (Week 2)  
Add learning hooks to all Rs2 methods:

```java
// ML-Enhanced API
Rs2Npc.attackWithLearning("Guard");
Rs2Combat.fightIntelligently();
```

### Phase 3: Advanced Features (Week 3-4)
- OpenCV visual recognition
- LLM decision making  
- Multi-client coordination
- Central management dashboard

## 🛠️ Development Commands

### Build FruneLight:
```bash
cd C:\Users\hp\Development\frunelight
gradlew clean build
```

### Run FruneLight:
```bash
gradlew run
```

### Test Dependencies:
```bash
gradlew test
```

## 📦 Framework Integration Strategy

We use compiled JARs as dependencies rather than modifying source code:

**✅ Benefits:**
- Clean separation of our code vs theirs
- Easy updates (recompile their JARs)
- No merge conflicts
- Full access to their APIs

**🎯 Implementation:**
- Import their classes directly in our code
- Build our Rs2 utility layer on top
- Add ML/AI enhancements to our layer
- Create unified FruneLight experience

## 🔧 Technical Architecture

```
┌─────────────────────────────────────────┐
│           FruneLight API Layer          │
│  (Rs2Npc, Rs2Bank, Rs2Combat, etc.)    │
├─────────────────────────────────────────┤
│              ML/AI Layer                │
│  (Learning, OpenCV, LLM decisions)     │
├─────────────────────────────────────────┤
│           Compiled Dependencies         │
│  melxin-runelite + devious + microbot   │
└─────────────────────────────────────────┘
```

## 📈 Success Metrics

### Technical Goals:
- ✅ All dependencies compiled and integrated
- 🔄 Complete Rs2 API coverage (in progress)
- 🔄 ML learning in all actions (planned)
- 🔄 Human-like behavior patterns (planned)

### User Experience Goals:
- Simple script creation with Rs2 utilities
- Intelligent automation without micromanagement  
- Multi-client coordination
- Advanced anti-detection

## 🎯 Vision Statement

**FruneLight = DreamBot's beautiful API + Our compiled power + ML intelligence**

Scripts will be as easy to write as DreamBot, as powerful as the combined frameworks, and as intelligent as modern AI allows.

---

**Status**: ✅ Foundation Complete - Ready for Rs2 API Development  
**Next Milestone**: Rs2 utility framework implementation  
**ETA**: Week 1 of development phase
