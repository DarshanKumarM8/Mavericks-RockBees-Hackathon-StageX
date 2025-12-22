<div align="center">

![DorsataSentry Banner](C:/Users/Darshankumar/.gemini/antigravity/brain/f391df9d-0188-4eb1-b3b7-78969c3ca43c/dorsata_sentry_banner_1766392720848.png)

# 🐝 DorsataSentry

### *Predictive Coexistence Engine for Urban Ecology* 🏙️

[![Made with Flutter](https://img.shields.io/badge/Made%20with-Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![TensorFlow Lite](https://img.shields.io/badge/TF%20Lite-FF6F00?style=for-the-badge&logo=tensorflow&logoColor=white)](https://www.tensorflow.org/lite)
[![OpenCV](https://img.shields.io/badge/OpenCV-5C3EE8?style=for-the-badge&logo=opencv&logoColor=white)](https://opencv.org/)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com/)

</div>

---

## 📖 Executive Summary

**DorsataSentry** is a mobile-first platform designed to solve the "Invisibility of Intent" conflict between urban development and the Giant Rock Bee (*Apis dorsata*). 

Current urban management treats all bee colonies as immediate threats because residents cannot distinguish between a calm hive and an agitated one. **DorsataSentry** transforms the user from a passive victim into an active **"Urban Ecologist"** by using advanced AI and "Visual Vibrometry" to detect, map, and monitor the behavioral state of colonies in real-time.

### 🎯 Core Innovation: The "Dorsata-Pulse"

We move beyond simple detection to **Behavioral State Estimation**, using Eulerian Video Magnification (EVM) to detect the colony's "shimmering" defense signals before an attack occurs.

---

## 🧬 Biological Foundation (The "Why")

Our solution is strictly grounded in the unique ethology of *Apis dorsata*, differentiating it from generic beekeeping apps.

*   **🏙️ The "Urban Cliff" Hypothesis:** *Apis dorsata* uses high-rise buildings as substitutes for natural limestone cliffs, preferring specific orientations and overhangs.
*   **🔄 Migratory Philopatry:** These bees exhibit strong site fidelity, returning to the *exact same anchor point* year after year. We use this to predict where "dormant" hives will reactivate in Oct-Nov.
*   **🌊 The "Shimmering" Defense Signal:** When threatened, the colony performs a coordinated "Mexican Wave" of abdominal flipping. Our app detects this graded signal to warn users of imminent danger.

---

## ✨ Integrated Solution Architecture

Our system operates on a hybrid **Edge-AI + Cloud GIS** architecture, integrating three critical layers:

<div align="center">

| 🔭 **Module 1: Hive Scouter** | 🗺️ **Module 2: Hive Atlas** | 💓 **Module 3: Behavioral Sentinel** |
|:----------------------------:|:---------------------------:|:------------------------------------:|
| **Detection Layer** | **Location & Migration Layer** | **Safety Layer** |
| On-device AI (YOLOv8) | 3D Urban Apiary Map | **"Dorsata-Pulse"** Visual Vibrometry |
| Distinguishes bees vs. wasps | Tracks "Active" vs. "Dormant" hives | **Colony Agitation Index (CAI)** |
| 🟢 Green Box: Correct ID | ⚠️ Migratory Alerts | 🟢 Safe \| 🟡 Caution \| 🔴 Danger |

</div>

### 💡 How It Works

```mermaid
graph TD
    User[📱 User / "Urban Ecologist"] -->|Points Camera| Detect[🔭 Module 1: Detection]
    Detect -->|YOLOv8 Identification| ID{Is it Apis dorsata?}
    ID -->|No / Wasp| Alert[🚫 Warning: Pest]
    ID -->|Yes| Locate[🗺️ Module 2: Localization]
    
    Locate -->|GPS + Barometer| Map[📍 Pin on Hive Atlas]
    Locate -->|Check History| Philopatry[🔄 Philopatry Check]
    
    Map -->|Analyze Video| Monitor[💓 Module 3: Sentinel]
    Monitor -->|Eulerian Mag + Optical Flow| Shimmer[🌊 Detect Shimmering]
    
    Shimmer -->|Calculate CAI| Safety{Agitation Level}
    Safety -->|Low < 20| Safe[🟢 Safe / Dormant]
    Safety -->|Med 20-60| Caution[🟡 Caution / Local Wave]
    Safety -->|High > 80| Danger[🔴 DANGER / Mass Attack]
    
    Philopatry -->|Season Start| Push[📲 Push Notification: Returning Swarm]
```

---

## 🛠️ Technology Stack

Designed for high performance on mobile devices with cloud synchronization.

| Component | Technology | Role |
| :--- | :--- | :--- |
| **Frontend** | ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white) | Cross-platform (iOS/Android) UI |
| **ML Engine** | ![TF Lite](https://img.shields.io/badge/TF_Lite-FF6F00?style=flat-square&logo=tensorflow&logoColor=white) | Runs quantized **YOLOv8 Nano** for on-device detection |
| **Vision** | ![OpenCV](https://img.shields.io/badge/OpenCV-5C3EE8?style=flat-square&logo=opencv&logoColor=white) | **Eulerian Video Magnification** & Optical Flow for Shimmer detection |
| **Backend** | ![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat-square&logo=firebase&logoColor=black) | **GeoFirestore** for clustering & Cloud Functions for alerts |
| **Mapping** | ![Google Maps](https://img.shields.io/badge/Google_Maps-4285F4?style=flat-square&logo=google-maps&logoColor=white) | Visualizes the "Hive Atlas" with Green/Red markers |

---

## 📊 Modules in Detail

### 1. The "Hive Scouter" (Detection)
*   User points phone at a structure.
*   **Green Box:** *Apis dorsata* (Confidence > 85%) - Validated.
*   **Red Box:** *Vespa* (Hornet/Wasp) - Pest Warning.
*   **Constraint:** Pins only drop after AI validation to prevent false reports.

### 2. The "Hive Atlas" (Context)
*   **Z-Axis Tracking:** Uses phone's barometer to log specific floor numbers.
*   **Migratory Alert:** Because bees return to the same spot, the app warns residents: *"Migratory Season Started: Check your balcony for returning swarms."*

### 3. The "Behavioral Sentinel" (Safety)
*   **Motion Magnification:** Amplifies micro-motions in the video feed.
*   **Shimmer Classification:** Detects velocity (~0.3-0.5 m/s) of the "Mexican Wave".
*   **Acoustic Validation:** Secondary check for broadband "hiss" (400Hz - 6kHz).
*   **Output:**
    *   🟢 **Green (CAI < 20):** Safe.
    *   🟡 **Yellow (CAI 20-60):** Localized Shimmering. Caution.
    *   🔴 **Red (CAI > 80):** **AGITATED - DO NOT APPROACH.**

---

## 🚀 Impact & Novelty

*   **Novelty:** Unlike apps that log "Presence" (e.g., iNaturalist), DorsataSentry logs **"Intent"**. The combination of Object Detection + Visual Vibrometry is a first-of-its-kind dual-layer approach.
*   **Patent Potential:** *"Method for Remote Behavioral State Estimation of Open-Nesting Hymenoptera using Optical Flow Vibrometry"*
*   **Scalability:** Software-only solution deployable on existing CCTV networks.

---

## 📚 Key References
1.  **Oldroyd, B. P., & Wongsiri, S. (2006).** *Asian Honey Bees: Biology, Conservation, and Human Interactions.*
2.  **Kastberger, G., et al. (2008).** *"Social waves in giant honeybees repel wasps."* PLoS ONE.
3.  **Wu, H. Y., et al. (2012).** *"Eulerian Video Magnification for Revealing Subtle Changes in the World."* ACM Transactions on Graphics.

---

<div align="center">

**🏆 RockBees Hackathon - StageX - Team Mavericks**

*Transforming Urban Conflict into Coexistence*

</div>