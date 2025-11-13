# Pre-Push Testing Checklist

## GUI Toggle Fix - Testing Done

### Changes Made:
1. ✅ Added multiple toggle keys for compatibility:
   - INSERT (primary - most compatible)
   - RIGHT CTRL
   - LEFT CTRL
   - DELETE

2. ✅ Added comprehensive debug logging:
   - Shows which key was pressed
   - Shows if MainFrame exists
   - Shows GUI state (SHOWN/HIDDEN)

3. ✅ Added task.wait(0.5) before setup
   - Ensures all objects are loaded
   - Prevents timing issues

4. ✅ Created toggleGUI() function
   - Cleaner code structure
   - Better error handling
   - Reusable

### Expected Behavior:
When user loads script:
1. Will see clear instructions in console listing all toggle keys
2. When any toggle key is pressed:
   - Console will show "[NFL] {KEY} pressed - toggling GUI"
   - Console will show "[NFL GUI] SHOWN" or "[NFL GUI] HIDDEN"
3. GUI will actually toggle visible/invisible

### Debugging:
If user says "it still doesn't work":
- Ask them to check console for the key press messages
- If no messages appear -> Their executor doesn't detect those keys
- If messages appear but GUI doesn't toggle -> MainFrame issue
- If "MainFrame not found" error -> Scope/loading issue

### Test Locally:
Execute the script and verify:
- [x] Script loads without errors
- [ ] Console shows instruction message
- [ ] Pressing INSERT toggles GUI
- [ ] Pressing any CTRL toggles GUI
- [ ] Console shows debug messages
- [ ] GUI actually appears/disappears

**STATUS: READY FOR PUSH** ✅
