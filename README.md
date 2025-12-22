<br />
<div align="center">
<a href="[https://github.com/github_username/repo_name](https://github.com/github_username/repo_name)">
<img src="[https://img.icons8.com/external-flaticons-lineal-color-flat-icons/64/external-bee-farm-flaticons-lineal-color-flat-icons-2.png](https://img.icons8.com/external-flaticons-lineal-color-flat-icons/64/external-bee-farm-flaticons-lineal-color-flat-icons-2.png)" alt="Logo" width="80" height="80">
</a>
<h1 align="center">DorsataSentry</h1>
<p align="center">
<b>AI-Driven Optical Detection & Ethological Monitoring for <i>Apis dorsata</i></b>
<br />
<a href="#demo">View Demo</a>
·
<a href="#proposed-solution-dorsatasentry">Explore Solution</a>
·
<a href="#references">Read Research</a>
</p>
</div>
<div align="center">

!(https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
!(https://img.shields.io/badge/TensorFlow-%23FF6F00.svg?style=for-the-badge&logo=TensorFlow&logoColor=white)
</div>
📋 Table of Contents
1.(#1-executive-summary)
2.(#2-overview-of-bees-and-rock-bees)
3.(#3-need-for-colony-monitoring)
4.(#4-research-topics)
-(#32-rock-bee-habitat--colony-patterns)
-(#34-existing-detection-methods--limitations)
5.(#5-proposed-solution-dorsatasentry)
-(#module-1-the-hive-scouter-optical-detection)
- Module 2: Migratory Map
-(#module-3-the-biosense-ethological-safety-analysis)
6.(#project-structure)
7.(#6-references)
1. Executive Summary
DorsataSentry is a mobile-first application designed to solve the human-wildlife conflict between urban residents and the Giant Rock Bee (Apis dorsata). Unlike standard beekeeping apps that manage wooden boxes, this solution uses Computer Vision and Sensor Fusion to detect wild, open-nesting colonies on high-rise buildings.
> Core Innovation: We treat the smartphone as a "Remote Biosensor," detecting the unique visual "shimmering" waves and acoustic "hissing" signals of Rock Bees to warn users of aggression before a sting occurs.
> 
2. Overview of Bees and Rock Bees
🌏 The Ecological Context
India is home to a diverse range of honey bee species. While Apis cerana and Apis mellifera are domesticated in boxes, the Giant Rock Bee (Apis dorsata) remains wild. It is a keystone pollinator, essential for India's agricultural economy, yet it cannot be kept in artificial hives.
🏙️ The Urban "Rock Bee" (Apis dorsata)
Apis dorsata has adapted remarkably to urbanization. In cities like Bangalore, Hyderabad, and Nagpur, they treat high-rise buildings, water tanks, and metro viaducts as "urban cliffs".
 * Behavior: They are migratory, highly defensive, and exhibit philopatry (they return to the exact same nesting site year after year).
 * Defense: They display a unique collective defense behavior called "Shimmering" (a visual wave of flipping abdomens) and produce a distinct "Hissing" sound when threatened.
3. Need for Colony Monitoring
The conflict is driven by a lack of visibility. Currently, a colony is often only "detected" when it attacks, leading to panic and the destruction of the hive (and the pollinators).
| Key Driver | Description |
|---|---|
| 🛡️ Public Safety | To warn residents of agitated colonies before a stinging incident occurs. |
| 🌿 Conservation | To prevent preemptive destruction by identifying safe, dormant, or calm colonies. |
| 📍 Migration Tracking | To predict when swarms will return to specific buildings, enabling proactive management. |
4. Research Topics
4.1 Types of Bees in India
 * 🐝 Apis dorsata (Rock Bee): The largest, most aggressive, and migratory. Open-nesting.
 * 🐝 Apis cerana (Indian Hive Bee): Cavity-nesting, domesticable.
 * 🐝 Apis florea (Little Bee): Small, open-nesting in bushes.
 * 🐝 Apis mellifera (European Bee): Imported for commercial beekeeping.
4.2 Rock Bee Habitat & Colony Patterns
 * The "Urban Cliff" Hypothesis: Apis dorsata prefers structures that mimic natural cliffs. Research in Nagpur found 60.8% of nests on buildings, compared to only 5.4% on trees.
 * Nesting Fidelity: Colonies leave white wax traces ("scars") on buildings when they migrate. Swarms use olfactory cues to return to these specific scars seasonally.
 * Orientation: Nests are often oriented East-West to manage thermoregulation on exposed buildings.
4.3 Existing Detection Methods & Limitations
| Technology | Method | Limitation for Apis dorsata |
|---|---|---|
| Manual Inspection | Visual check by pest control | Slow, reactive, and dangerous for the inspector. |
| IoT Sensors | Temp/Humidity sensors | Requires installation inside a box. Impossible for open-nesting wild bees. |
| Citizen Science Apps | iNaturalist / Epicollect | Good for photos, but lacks real-time safety analysis or agitation warnings. |
| LIDAR/Radar | Laser detection | Effective but prohibitively expensive for widespread urban use. |
5. Proposed Solution: "DorsataSentry"
DorsataSentry is a software-only solution that repurposes smartphone sensors to detect, map, and monitor Rock Bee colonies without physical contact.
🔭 Module 1: The "Hive Scouter" (Optical Detection)
 * Technology: On-device Computer Vision (YOLOv8 optimized for TensorFlow Lite).
 * Function: The user points the camera at a distant building. The AI detects the specific visual signature of the Apis dorsata curtain (large, semi-circular, dark mass).
 * Innovation: It distinguishes Rock Bees from wasp nests or AC units, validating the data source.
🗺️ Module 2: The "Migratory Map" (Location Monitoring)
 * Technology: Geolocation (GPS) + Time-Lapse Crowdsourcing.
 * Function:
   * Logs the precise coordinates and altitude (floor level) of hives.
   * Tracks the status: "Active" (Live Bees) vs. "Dormant" (Wax Scar).
   * Predictive Alert: Uses historical data of "Dormant" sites to warn residents when the migration season begins: "Bees are likely to return to your balcony this week.".
📡 Module 3: The "BioSense" (Ethological Safety Analysis)
 * Technology: Optical Flow (Farneback Algorithm) & Spectral Audio Analysis.
 * Visual Safety: Detects "Shimmering"—the rhythmic defense waves bees display before attacking. If the app sees pixel movement at 0.3–0.5 m/s (wave velocity), it triggers a Red Alert.
 * Audio Safety: Detects "Hissing", identifying the specific frequency spike (400Hz – 6kHz) associated with colony aggression, filtering out traffic noise.
📂 Project Structure
DorsataSentry/
├── docs/
│   ├── research.pdf          # Detailed Research Report
│   └── reference-links.txt   # List of sources
├── assets/
│   └── images/               # Infographics and Diagrams
├── README.md                 # This file
└── LICENSE

6. References
 * Wardhe, D.S. & Ghonmode, S.V. (2024). Nesting pattern of Apis dorsata F. in urban Nagpur. Entomon, 49(4): 539-544. (Evidence for urban nesting preferences on buildings).
 * Kastberger, G., et al. (2014). Speeding up social waves: Propagation mechanisms of shimmering in giant honeybees. PLOS ONE. (Scientific basis for visual defense detection). 
 * Wehmann, H., et al. (2015). The Sound and the Fury—Bees Hiss when Expecting Danger. PLOS ONE. (Scientific basis for acoustic monitoring). 
 * Oldroyd, B.P., et al. (2000). Colony aggregation and seasonal migration in Apis dorsata. (Evidence for philopatry and returning to the same sites). 
 * Vijayan, S., et al. (2022). Defensive shimmering responses in Apis dorsata are triggered by dark stimuli. Journal of Experimental Biology. (Visual triggers for aggression). 
<div align="center">
<sub>Built for the Rock Bees Colony Hackathon (Stage 1)</sub>
</div>