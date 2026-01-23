# Quick Test Guide

Fast testing guide for tomorrow's verification.

## 🚀 Quick Start (3 Steps)

```bash
# 1. Clone and setup
git clone https://github.com/JaredUbriaco/AGAnsible.git
cd AGAnsible
chmod +x install.sh
./install.sh

# 2. Verify
./verify.sh

# 3. Test everything
./test_all.sh
```

## ✅ What to Expect

### After `./install.sh`:
- Python3, pip3, Ansible installed
- curl, dnsutils, git installed
- All tools verified

### After `./verify.sh`:
- All checks should show ✅
- No failures

### After `./test_all.sh`:
- 3 tests run (ping, curl, DNS)
- All should pass ✅
- Actionlog files created

## 📋 Quick Checklist

- [ ] `./install.sh` completes without errors
- [ ] `./verify.sh` shows all ✅
- [ ] `./test_all.sh` shows all tests pass
- [ ] Actionlog files exist in `actionlog/` directories

## 🔍 If Something Fails

1. Check the error message
2. Verify network connectivity: `ping -c 4 8.8.8.8`
3. Re-run `./install.sh` if tools missing
4. Check `TESTING_CHECKLIST.md` for detailed troubleshooting

## 📊 Expected Test Results

```
✅ PASS - Ping Test
✅ PASS - Curl Test  
✅ PASS - DNS Test

Tests Run: 3
Passed: 3
Failed: 0
```

---

**That's it!** If all tests pass, you're ready to go! 🎉
