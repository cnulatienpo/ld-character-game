# GM2 Full Beginner Workflow (With ELI5 Notes)

This guide is for first-time GameMaker users who want to get this project running safely.
The goal is simple: open the project, connect the scripts, run the game, test grading, and export.

## Phase 1: Get Your Workspace Calm And Ready

1. Open VS Code in this repository and make sure your recent migration files exist.
ELI5: Before building a toy, put all toy pieces on the table so nothing is missing.

2. Confirm these key files are present:
- [Scripts/scr_character_grader_native.gml](Scripts/scr_character_grader_native.gml)
- [Scripts/scr_character_grader_native_selftest.gml](Scripts/scr_character_grader_native_selftest.gml)
- [scripts/gamemaker/scripts/scr_submitText.gml](scripts/gamemaker/scripts/scr_submitText.gml)
- [Objects/obj_feedback_panel_Step.gml](Objects/obj_feedback_panel_Step.gml)
- [Objects/obj_feedback_panel_Draw.gml](Objects/obj_feedback_panel_Draw.gml)
- [Scripts/scr_api.gml](Scripts/scr_api.gml)
- [Scripts/scr_http.gml](Scripts/scr_http.gml)
- [Scripts/scr_net_config.gml](Scripts/scr_net_config.gml)
- [Objects/obj_bootstrap_Create.gml](Objects/obj_bootstrap_Create.gml)
ELI5: These are the engine, steering wheel, and dashboard lights.

3. Keep your current backup point by not deleting extra folders yet.
ELI5: Do not throw away spare parts until the bike actually rides.

## Phase 2: Open GameMaker And Create Your Project Shell

1. Install GameMaker and launch it.
ELI5: First you open the game-building app, like opening a big box of building blocks.

2. Create a new project using the same runtime style you plan to ship with (usually GameMaker Language 2).
ELI5: Pick the same kind of toy tracks now that you will use later, so trains fit.

3. Save the project in a dedicated folder for this game build.
ELI5: Give your toy box a permanent shelf so pieces do not get lost.

4. In GameMaker, create the top-level resource groups if they do not exist yet:
- Objects
- Rooms
- Scripts
ELI5: Make labeled bins before sorting parts into them.

## Phase 3: Import Core Runtime Scripts First

1. Import or create scripts in this order:
- [Scripts/scr_json_read.gml](Scripts/scr_json_read.gml)
- [Scripts/scr_jsonl_read.gml](Scripts/scr_jsonl_read.gml)
- [Scripts/scr_net_config.gml](Scripts/scr_net_config.gml)
- [Scripts/scr_http.gml](Scripts/scr_http.gml)
- [Scripts/scr_api.gml](Scripts/scr_api.gml)
- [Scripts/scr_character_grader_native.gml](Scripts/scr_character_grader_native.gml)
- [Scripts/scr_character_grader_native_selftest.gml](Scripts/scr_character_grader_native_selftest.gml)
ELI5: Put in the power cables and batteries before trying to turn on lights.

2. Import the active submit path script:
- [scripts/gamemaker/scripts/scr_submitText.gml](scripts/gamemaker/scripts/scr_submitText.gml)
ELI5: This is the Send button brain. Without it, answers go nowhere.

3. Import feedback support script if your room flow uses it:
- [scripts/gamemaker/scripts/scr_showFeedback.gml](scripts/gamemaker/scripts/scr_showFeedback.gml)
ELI5: This is the message reader that tells the player what happened.

## Phase 4: Import Key Objects And Hook Their Events

1. Import the bootstrap object event code:
- [Objects/obj_bootstrap_Create.gml](Objects/obj_bootstrap_Create.gml)
ELI5: This is the wake-up checklist the game runs when it first opens.

2. Import the feedback panel events:
- [Objects/obj_feedback_panel_Step.gml](Objects/obj_feedback_panel_Step.gml)
- [Objects/obj_feedback_panel_Draw.gml](Objects/obj_feedback_panel_Draw.gml)
ELI5: One part thinks each frame, the other part paints words on screen.

3. Import submit button event wiring:
- [Objects/obj_submit_LeftPressed.gml](Objects/obj_submit_LeftPressed.gml)
ELI5: This is the doorbell that calls the grading script when clicked.

4. Make sure your lesson flow object that resets feedback is present:
- [Objects/obj_lesson_controller_Create.gml](Objects/obj_lesson_controller_Create.gml)
ELI5: This clears old chalk from the board before each new lesson.

## Phase 5: Import Required Data Files

1. Include dataset files that your lesson and mini-games expect, especially:
- [dataset/index.json](dataset/index.json)
- [dataset/examples_by_seed.json](dataset/examples_by_seed.json)
- [dataset/character_full_master.seeder.json](dataset/character_full_master.seeder.json)
ELI5: These are your question cards and answer books.

2. Include lesson payloads used by backend or local lesson logic:
- [character_api/data/lessons](character_api/data/lessons)
ELI5: This is the stack of story pages the game reads from.

3. If your room scripts depend on quiz packs, include:
- [dataset/quizzes](dataset/quizzes)
ELI5: This is the multiple-choice notebook the quiz rooms open.

## Phase 6: Configure Runtime API Safely

1. Start with local API default from [Scripts/scr_net_config.gml](Scripts/scr_net_config.gml).
ELI5: First talk to a helper on your own machine.

2. For deployed backend, set global.api_base_url during startup in your boot flow.
ELI5: Change the phone number so the game calls your online server, not your laptop.

3. Keep Content-Type as application/json in [Scripts/scr_net_config.gml](Scripts/scr_net_config.gml).
ELI5: This tells the server your message is packed in the right envelope.

## Phase 7: First Playable Run Inside GM2

1. Press Run in GameMaker.
ELI5: Turn the key in the car and see if engine starts.

2. Go to lesson screen, type a response, and press submit.
ELI5: Say one sentence into the toy microphone and see if it answers back.

3. Confirm feedback appears and game does not freeze.
ELI5: Make sure the toy lights up instead of getting stuck.

4. Look for optional unlock debug line under feedback.
ELI5: This is a sticker saying which new powers you earned.

## Phase 8: Run Built-In Native Grader Self-Test

1. While feedback panel is active, press F9.
ELI5: Push the secret test button.

2. Confirm panel shows a summary like passed over total.
ELI5: It should say how many homework questions got right.

3. If not all pass, check debug output and keep game running while fixing scripts.
ELI5: If one wheel is wobbly, tighten that wheel first, not the whole bike.

## Phase 9: Common Problems And Exact Fix Direction

1. Symptom: No feedback text after submit.
Fix focus:
- [scripts/gamemaker/scripts/scr_submitText.gml](scripts/gamemaker/scripts/scr_submitText.gml)
- [Objects/obj_submit_LeftPressed.gml](Objects/obj_submit_LeftPressed.gml)
ELI5: The send button was pressed, but the mail truck never left.

2. Symptom: F9 says self-test script missing.
Fix focus:
- [Scripts/scr_character_grader_native_selftest.gml](Scripts/scr_character_grader_native_selftest.gml)
- [Objects/obj_feedback_panel_Step.gml](Objects/obj_feedback_panel_Step.gml)
ELI5: You rang the test bell, but the bell wire was not connected.

3. Symptom: API calls fail.
Fix focus:
- [Scripts/scr_net_config.gml](Scripts/scr_net_config.gml)
- [Scripts/scr_api.gml](Scripts/scr_api.gml)
ELI5: Your letter had the wrong address.

4. Symptom: Unlocks never show.
Fix focus:
- [Scripts/scr_character_grader_native.gml](Scripts/scr_character_grader_native.gml)
- [scripts/gamemaker/scripts/scr_submitText.gml](scripts/gamemaker/scripts/scr_submitText.gml)
- [Objects/obj_feedback_panel_Draw.gml](Objects/obj_feedback_panel_Draw.gml)
ELI5: You won coins, but the game forgot to open the coin pocket.

## Phase 10: Export Preparation

1. Re-run one full lesson loop and one mini-game loop before export.
ELI5: Do one full test lap before race day.

2. Confirm no missing-file errors for dataset loads.
ELI5: Make sure every page the game asks for is actually in the backpack.

3. Keep conservative cleanup policy for now.
Safe to remove now:
- [GameIntro.jsx](GameIntro.jsx)
Defer removal until one stable shipped build:
- [src](src)
- [ld_patch](ld_patch)
- [web](web)
- [character-grader/src](character-grader/src)
- [character-grader/dist](character-grader/dist)
ELI5: Throw away obvious trash now, keep maybe-useful boxes until moving day is done.

## Phase 11: Final Confidence Routine (Do This Every Build)

1. Start game.
2. Submit one lesson response.
3. Verify feedback appears.
4. Press F9.
5. Verify self-test summary appears.
6. Verify no crash.
7. Save and export.

ELI5: Same seven moves every time means fewer surprises.
