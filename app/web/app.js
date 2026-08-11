document.addEventListener('DOMContentLoaded', () => {
    const loginModal = document.getElementById('login-modal');
    const appShell = document.getElementById('app-shell');
    const loginForm = document.getElementById('login-form');
    const loginBtn = document.getElementById('login-btn');
    const quickLoginBtn = document.getElementById('quick-login-btn');
    const loginError = document.getElementById('login-error');
    
    const charNameText = document.getElementById('metric-char');
    const charIdText = document.getElementById('metric-char-id');
    const activityLog = document.getElementById('activity-log');
    
    let sessionState = {
        sessionkey: null,
        char_id: null,
        char_name: null,
        level: '--',
        xp: '--',
        gold: '--',
        tokens: '--'
    };

    function addLog(msg) {
        const li = document.createElement('li');
        const msgDiv = document.createElement('div');
        msgDiv.textContent = msg;
        
        const timeSmall = document.createElement('small');
        const now = new Date();
        timeSmall.textContent = now.getHours().toString().padStart(2, '0') + ':' + now.getMinutes().toString().padStart(2, '0') + ':' + now.getSeconds().toString().padStart(2, '0');
        
        li.appendChild(msgDiv);
        li.appendChild(timeSmall);
        activityLog.insertBefore(li, activityLog.firstChild);
        
        if (activityLog.children.length > 50) {
            activityLog.removeChild(activityLog.lastChild);
        }
    }

    function checkLoginState() {
        const stored = localStorage.getItem('ns_session');
        if (stored) {
            sessionState = JSON.parse(stored);
            charNameText.textContent = sessionState.char_name || "Unknown";
            charIdText.textContent = sessionState.char_id || "Unknown";
            
            // Populate stats
            document.getElementById('metric-level').textContent = sessionState.level || '--';
            document.getElementById('metric-xp').textContent = sessionState.xp || '--';
            document.getElementById('metric-gold').textContent = sessionState.gold || '--';
            document.getElementById('metric-token').textContent = sessionState.tokens || '--';
            
            loginModal.classList.add('hidden');
            appShell.classList.remove('hidden');
            addLog("Loaded session from LocalStorage.");
        } else {
            loginModal.classList.remove('hidden');
            appShell.classList.add('hidden');
        }
    }

    function addStartupLog(msg, type = 'ok') {
        const startupLogs = document.getElementById('startup-logs');
        if (!startupLogs) return;
        const li = document.createElement('li');
        
        const timeSpan = document.createElement('span');
        timeSpan.className = 'log-time';
        const now = new Date();
        timeSpan.textContent = now.getHours().toString().padStart(2, '0') + ':' + 
                               now.getMinutes().toString().padStart(2, '0') + ':' + 
                               now.getSeconds().toString().padStart(2, '0');
        
        const dotDiv = document.createElement('div');
        dotDiv.className = `log-dot ${type}`;
        
        const msgSpan = document.createElement('span');
        msgSpan.textContent = msg;
        if (type === 'ok') msgSpan.style.color = '#10b981';
        if (type === 'warn') msgSpan.style.color = '#f59e0b';
        if (type === 'err') msgSpan.style.color = '#ef4444';
        
        li.appendChild(timeSpan);
        li.appendChild(dotDiv);
        li.appendChild(msgSpan);
        
        startupLogs.appendChild(li);
        startupLogs.parentElement.scrollTop = startupLogs.parentElement.scrollHeight;
    }

    loginForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        const user = document.getElementById('login-user').value;
        const pass = document.getElementById('login-pass').value;
        
        loginBtn.disabled = true;
        loginBtn.innerHTML = "Logging in... &rarr;";
        
        addStartupLog(`Login attempt for ${user}`, 'warn');
        
        try {
            const res = await fetch('/api/auth/login', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ username: user, password: pass })
            });
            const data = await res.json();
            
            if (data.status === 'success') {
                addStartupLog(`Login successful for ${user}`, 'ok');
                addStartupLog(`Selected character: ${data.char_name}`, 'ok');
                sessionState = {
                    sessionkey: data.sessionkey,
                    char_id: data.char_id,
                    char_name: data.char_name,
                    level: data.level || '--',
                    xp: data.xp || '--',
                    gold: data.gold || '--',
                    tokens: data.tokens || '--'
                };
                localStorage.setItem('ns_session', JSON.stringify(sessionState));
                localStorage.setItem('ns_quick_login', JSON.stringify({ user, pass }));
                setTimeout(() => checkLoginState(), 1000); // Give user time to read logs
            } else {
                addStartupLog(data.message || "Login failed", 'err');
            }
        } catch (err) {
            addStartupLog("Network error occurred", 'err');
        } finally {
            loginBtn.disabled = false;
            loginBtn.innerHTML = "Login &rarr;";
        }
    });

    if (quickLoginBtn) {
        quickLoginBtn.addEventListener('click', () => {
            const stored = localStorage.getItem('ns_quick_login');
            if (stored) {
                const creds = JSON.parse(stored);
                document.getElementById('login-user').value = creds.user;
                document.getElementById('login-pass').value = creds.pass;
                addStartupLog("Quick login credentials loaded", 'ok');
                document.getElementById('login-form').dispatchEvent(new Event('submit', { cancelable: true, bubbles: true }));
            } else {
                addStartupLog("No saved credentials for Quick Login", 'warn');
            }
        });
    }

    document.getElementById('btn-logout').addEventListener('click', () => {
        localStorage.removeItem('ns_session');
        sessionState = { sessionkey: null, char_id: null, char_name: null, level: '--', xp: '--', gold: '--', tokens: '--' };
        activityLog.innerHTML = '<li><div>Ready for commands...</div><small>System</small></li>';
        checkLoginState();
    });

    // Command Handlers
    document.querySelectorAll('.cmd-btn').forEach(btn => {
        btn.addEventListener('click', async (e) => {
            const action = e.target.dataset.action;
            const params = {};

            if (action === 'mission') {
                const missionId = document.getElementById('mission_id').value;
                if (!missionId) {
                    alert('Please enter a Mission ID');
                    return;
                }
                params.mission_id = missionId;
            } else if (action === 'hunting') {
                const zone = document.getElementById('hunting_zone').value;
                if (!zone) {
                    alert('Please enter a Hunting Zone');
                    return;
                }
                params.zone = parseInt(zone);
            }

            e.target.disabled = true;
            e.target.style.opacity = '0.5';
            addLog(`Executing ${action}...`);

            try {
                const res = await fetch('/api/bot/command', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ 
                        action, 
                        sessionkey: sessionState.sessionkey,
                        char_id: sessionState.char_id,
                        params 
                    })
                });
                const data = await res.json();
                if (data.status === 'success') {
                    addLog(`Success: ${data.result}`);
                } else {
                    addLog(`Error: ${data.message}`);
                }
            } catch (err) {
                addLog(`Network Error: ${err.message}`);
            } finally {
                e.target.disabled = false;
                e.target.style.opacity = '1';
            }
        });
    });

    // --- Automation Loops (Smart Client) ---
    
    // Global Bot Status Manager
    let currentRunningBotBtn = null;
    const statusText = document.getElementById('bot-status-text');
    const stopGlobalBtn = document.getElementById('global-stop-btn');

    window.stopCurrentBot = function() {
        if (currentRunningBotBtn) {
            currentRunningBotBtn.click();
        }
    };

    document.querySelectorAll('.btn-toggle').forEach(btn => {
        btn.addEventListener('click', function() {
            setTimeout(() => {
                if (this.textContent === "STOP") {
                    if (currentRunningBotBtn && currentRunningBotBtn !== this) {
                        currentRunningBotBtn.click();
                    }
                    currentRunningBotBtn = this;
                    let botName = this.previousElementSibling.querySelector('h4').textContent;
                    if (statusText) {
                        statusText.textContent = "Running: " + botName;
                        statusText.style.color = "#10b981";
                    }
                    if (stopGlobalBtn) stopGlobalBtn.style.display = "block";
                } else {
                    if (currentRunningBotBtn === this) {
                        currentRunningBotBtn = null;
                        if (statusText) {
                            statusText.textContent = "Idle - No bot is currently running.";
                            statusText.style.color = "#eee";
                        }
                        if (stopGlobalBtn) stopGlobalBtn.style.display = "none";
                    }
                }
            }, 10);
        });
    });
    
    // Auto Leveling
    let autoLevelInterval = null;
    let autoLevelTarget = 0;
    const btnAutoLevel = document.getElementById('toggle-autolevel');
    
    btnAutoLevel.addEventListener('click', () => {
        if (autoLevelInterval) {
            clearInterval(autoLevelInterval);
            autoLevelInterval = null;
            btnAutoLevel.textContent = "START";
            btnAutoLevel.style.background = "";
            addLog("Auto Leveling STOPPED.");
            return;
        }
        
        btnAutoLevel.textContent = "STOP";
        btnAutoLevel.style.background = "#ff5252";
        // Get the level from the UI metric if available, otherwise fallback to input
        const metricLevelStr = document.getElementById('metric-level').textContent;
        let charLevel = parseInt(metricLevelStr);
        if (isNaN(charLevel)) {
            charLevel = parseInt(document.getElementById('auto_level_max').value || 60);
        }
        
        autoLevelTarget = charLevel;
        
        addLog(`Auto Leveling STARTED (Targeting msn_${autoLevelTarget} based on Character Level)...`);
        
        autoLevelInterval = setInterval(async () => {
            if (autoLevelTarget < 1) {
                addLog("Invalid mission level. Stopping.");
                btnAutoLevel.click();
                return;
            }
            
            // First try taking exam if eligible
            try {
                const examRes = await fetch('/api/bot/auto_exam_step', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ 
                        sessionkey: sessionState.sessionkey,
                        char_id: sessionState.char_id
                    })
                });
                if (examRes.ok) {
                    const examData = await examRes.json();
                    if (!examData.message.includes("No exams available")) {
                        addLog(`[Exam System] ${examData.message}`, 'ok');
                    }
                }
            } catch (e) {
                console.error("Exam check failed", e);
            }
            
            // Then run normal leveling
            try {
                const res = await fetch('/api/bot/auto_leveling_step', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        sessionkey: sessionState.sessionkey,
                        char_id: sessionState.char_id,
                        mission_id: `msn_${autoLevelTarget}`
                    })
                });
                const data = await res.json();
                if (data.status === 'success' && !data.message.includes("Failed")) {
                    addLog(`[AutoLevel] msn_${autoLevelTarget} Success: ${data.message}`);
                } else {
                    addLog(`[AutoLevel] msn_${autoLevelTarget} Response: ${data.message}`);
                }
            } catch(e) {
                addLog(`[AutoLevel] Error: ${e.message}`);
            }
        }, 4000); // 4 seconds delay
    });

    // Auto Daily
    let autoDailyInterval = null;
    const btnAutoDaily = document.getElementById('toggle-autodaily');
    
    btnAutoDaily.addEventListener('click', () => {
        if (autoDailyInterval) {
            clearInterval(autoDailyInterval);
            autoDailyInterval = null;
            btnAutoDaily.textContent = "START";
            btnAutoDaily.style.background = "";
            addLog("Auto Daily STOPPED.");
            return;
        }
        
        btnAutoDaily.textContent = "STOP";
        btnAutoDaily.style.background = "#ff5252";
        addLog(`Auto Daily STARTED...`);
        
        autoDailyInterval = setInterval(async () => {
            try {
                const res = await fetch('/api/bot/auto_daily_step', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ 
                        sessionkey: sessionState.sessionkey,
                        char_id: sessionState.char_id
                    })
                });
                const data = await res.json();
                
                addLog(`[AutoDaily] Response: ${data.message}`);
                
                if (data.message === "Daily missions completed" || data.message === "No available daily missions (or failed to fetch)") {
                    btnAutoDaily.click();
                }
            } catch(e) {
                addLog(`[AutoDaily] Error: ${e.message}`);
            }
        }, 6000);
    });

    // Auto Hunting
    let autoHuntInterval = null;
    let currentHuntZone = 1;
    const btnAutoHunt = document.getElementById('toggle-autohunting');
    
    btnAutoHunt.addEventListener('click', () => {
        if (autoHuntInterval) {
            clearInterval(autoHuntInterval);
            autoHuntInterval = null;
            btnAutoHunt.textContent = "START";
            btnAutoHunt.style.background = "";
            addLog("Auto Hunting STOPPED.");
            return;
        }
        
        btnAutoHunt.textContent = "STOP";
        btnAutoHunt.style.background = "#ff5252";
        currentHuntZone = 1;
        addLog(`Auto Hunting STARTED...`);
        
        autoHuntInterval = setInterval(async () => {
            try {
                const res = await fetch('/api/bot/auto_hunting_step', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ 
                        sessionkey: sessionState.sessionkey,
                        char_id: sessionState.char_id,
                        zone: currentHuntZone
                    })
                });
                const data = await res.json();
                
                if (data.message && data.message.includes("Stopped")) {
                    addLog(`[AutoHunt] ${data.message}`);
                    btnAutoHunt.click(); // Stop the loop by triggering button click
                    return;
                }
                
                if (data.status === 'success' && !data.message.includes("Failed") && !data.message.includes("Unknown boss")) {
                    addLog(`[AutoHunt] Zone ${currentHuntZone} Success: ${data.message}`);
                    currentHuntZone++;
                    if (currentHuntZone > 5) currentHuntZone = 1;
                } else {
                    addLog(`[AutoHunt] Zone ${currentHuntZone} Failed: ${data.message || data.status}. Moving to next zone...`);
                    currentHuntZone++;
                    if (currentHuntZone > 5) currentHuntZone = 1;
                }
            } catch(e) {
                addLog(`[AutoHunt] Error: ${e.message}`);
            }
        }, 5000); // 5 seconds delay for boss fights
    });

    // Eudemon Boss (Desktop & Mobile share same logic if we use querySelectorAll)
    const eudemonBtns = document.querySelectorAll('#btnAutoEudemon');
    eudemonBtns.forEach(btn => {
        btn.addEventListener('click', async () => {
            if (!sessionState.sessionkey) return;
            const originalText = btn.innerHTML;
            btn.innerHTML = 'WAIT...';
            btn.disabled = true;
            
            try {
                addLog(`[Eudemon] Starting auto Eudemon boss fights...`);
                const res = await fetch('/api/bot/auto_eudemon', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ 
                        sessionkey: sessionState.sessionkey,
                        char_id: sessionState.char_id
                    })
                });
                const data = await res.json();
                
                if (data.status === 'success') {
                    addLog(`[Eudemon] Result:\n${data.message}`, 'ok');
                } else {
                    addLog(`[Eudemon] Failed: ${data.message}`, 'error');
                }
            } catch (e) {
                addLog(`[Eudemon] Error: ${e.message}`, 'error');
            }
            
            btn.innerHTML = originalText;
            btn.disabled = false;
        });
    });

    // Circus Event - Shadow Ringmaster
    let autoRingmasterInterval = null;
    const btnAutoRingmaster = document.getElementById('toggle-autoringmaster');

    if (btnAutoRingmaster) {
        btnAutoRingmaster.addEventListener('click', () => {
            if (autoRingmasterInterval) {
                clearInterval(autoRingmasterInterval);
                autoRingmasterInterval = null;
                btnAutoRingmaster.textContent = "START";
                btnAutoRingmaster.style.background = "";
                addLog("Auto Ringmaster STOPPED.");
                return;
            }

            btnAutoRingmaster.textContent = "STOP";
            btnAutoRingmaster.style.background = "#ff5252";
            addLog(`Auto Ringmaster STARTED...`);

            autoRingmasterInterval = setInterval(async () => {
                try {
                    const res = await fetch('/api/bot/auto_event_step', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ 
                            sessionkey: sessionState.sessionkey,
                            char_id: sessionState.char_id,
                            event_id: 'circus_ringmaster'
                        })
                    });
                    const data = await res.json();
                    addLog(`[Ringmaster] Response: ${data.message}`);
                    if (data.message && (data.message.toLowerCase().includes('failed') || data.message.toLowerCase().includes('energy') || data.message.toLowerCase().includes('ticket'))) {
                        btnAutoRingmaster.click();
                    }
                } catch(e) {
                    addLog(`[Ringmaster] Error: ${e.message}`);
                }
            }, 5000);
        });
    }

    // Circus Event - Nightmare Jester
    let autoJesterInterval = null;
    const btnAutoJester = document.getElementById('toggle-autojester');

    if (btnAutoJester) {
        btnAutoJester.addEventListener('click', () => {
            if (autoJesterInterval) {
                clearInterval(autoJesterInterval);
                autoJesterInterval = null;
                btnAutoJester.textContent = "START";
                btnAutoJester.style.background = "";
                addLog("Auto Jester STOPPED.");
                return;
            }

            btnAutoJester.textContent = "STOP";
            btnAutoJester.style.background = "#ff5252";
            addLog(`Auto Jester STARTED...`);

            autoJesterInterval = setInterval(async () => {
                try {
                    const res = await fetch('/api/bot/auto_event_step', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ 
                            sessionkey: sessionState.sessionkey,
                            char_id: sessionState.char_id,
                            event_id: 'circus_jester'
                        })
                    });
                    const data = await res.json();
                    addLog(`[Jester] Response: ${data.message}`);
                    if (data.message && (data.message.toLowerCase().includes('failed') || data.message.toLowerCase().includes('energy') || data.message.toLowerCase().includes('ticket'))) {
                        btnAutoJester.click();
                    }
                } catch(e) {
                    addLog(`[Jester] Error: ${e.message}`);
                }
            }, 5000);
        });
    }

    // Yokai Event - Kitsune
    let autoKitsuneInterval = null;
    const btnAutoKitsune = document.getElementById('toggle-autokitsune');

    if (btnAutoKitsune) {
        btnAutoKitsune.addEventListener('click', () => {
            if (autoKitsuneInterval) {
                clearInterval(autoKitsuneInterval);
                autoKitsuneInterval = null;
                btnAutoKitsune.textContent = "START";
                btnAutoKitsune.style.background = "";
                addLog("Auto Yokai Kitsune STOPPED.");
                return;
            }

            btnAutoKitsune.textContent = "STOP";
            btnAutoKitsune.style.background = "#ff5252";
            addLog(`Auto Yokai Kitsune STARTED...`);

            autoKitsuneInterval = setInterval(async () => {
                try {
                    const res = await fetch('/api/bot/auto_event_step', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ 
                            sessionkey: sessionState.sessionkey,
                            char_id: sessionState.char_id,
                            event_id: 'yokai_kitsune'
                        })
                    });
                    const data = await res.json();
                    addLog(`[Kitsune] Response: ${data.message}`);
                    if (data.message && (data.message.toLowerCase().includes('failed') || data.message.toLowerCase().includes('energy') || data.message.toLowerCase().includes('ticket'))) {
                        btnAutoKitsune.click();
                    }
                } catch(e) {
                    addLog(`[Kitsune] Error: ${e.message}`);
                }
            }, 5000);
        });
    }

    // Yokai Event - Tengu
    let autoTenguInterval = null;
    const btnAutoTengu = document.getElementById('toggle-autotengu');

    if (btnAutoTengu) {
        btnAutoTengu.addEventListener('click', () => {
            if (autoTenguInterval) {
                clearInterval(autoTenguInterval);
                autoTenguInterval = null;
                btnAutoTengu.textContent = "START";
                btnAutoTengu.style.background = "";
                addLog("Auto Yokai Tengu STOPPED.");
                return;
            }

            btnAutoTengu.textContent = "STOP";
            btnAutoTengu.style.background = "#ff5252";
            addLog(`Auto Yokai Tengu STARTED...`);

            autoTenguInterval = setInterval(async () => {
                try {
                    const res = await fetch('/api/bot/auto_event_step', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ 
                            sessionkey: sessionState.sessionkey,
                            char_id: sessionState.char_id,
                            event_id: 'yokai_tengu'
                        })
                    });
                    const data = await res.json();
                    addLog(`[Tengu] Response: ${data.message}`);
                    if (data.message && (data.message.toLowerCase().includes('failed') || data.message.toLowerCase().includes('energy') || data.message.toLowerCase().includes('ticket'))) {
                        btnAutoTengu.click();
                    }
                } catch(e) {
                    addLog(`[Tengu] Error: ${e.message}`);
                }
            }, 5000);
        });
    }

    // Yokai Event - Nurarihyon
    let autoNurarihyonInterval = null;
    const btnAutoNurarihyon = document.getElementById('toggle-autonurarihyon');

    if (btnAutoNurarihyon) {
        btnAutoNurarihyon.addEventListener('click', () => {
            if (autoNurarihyonInterval) {
                clearInterval(autoNurarihyonInterval);
                autoNurarihyonInterval = null;
                btnAutoNurarihyon.textContent = "START";
                btnAutoNurarihyon.style.background = "";
                addLog("Auto Yokai Nurarihyon STOPPED.");
                return;
            }

            btnAutoNurarihyon.textContent = "STOP";
            btnAutoNurarihyon.style.background = "#ff5252";
            addLog(`Auto Yokai Nurarihyon STARTED...`);

            autoNurarihyonInterval = setInterval(async () => {
                try {
                    const res = await fetch('/api/bot/auto_event_step', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ 
                            sessionkey: sessionState.sessionkey,
                            char_id: sessionState.char_id,
                            event_id: 'yokai_nurarihyon'
                        })
                    });
                    const data = await res.json();
                    addLog(`[Nurarihyon] Response: ${data.message}`);
                    if (data.message && (data.message.toLowerCase().includes('failed') || data.message.toLowerCase().includes('energy') || data.message.toLowerCase().includes('ticket'))) {
                        btnAutoNurarihyon.click();
                    }
                } catch(e) {
                    addLog(`[Nurarihyon] Error: ${e.message}`);
                }
            }, 5000);
        });
    }
    
    // Yokai Minigame
    let autoYokaiMinigameInterval = null;
    const btnAutoYokaiMinigame = document.getElementById('toggle-autoyokaiminigame');

    if (btnAutoYokaiMinigame) {
        btnAutoYokaiMinigame.addEventListener('click', () => {
            if (autoYokaiMinigameInterval) {
                clearInterval(autoYokaiMinigameInterval);
                autoYokaiMinigameInterval = null;
                btnAutoYokaiMinigame.textContent = "START";
                btnAutoYokaiMinigame.style.background = "";
                addLog("Auto Yokai Minigame STOPPED.");
                return;
            }

            btnAutoYokaiMinigame.textContent = "STOP";
            btnAutoYokaiMinigame.style.background = "#ff5252";
            addLog(`Auto Yokai Minigame STARTED...`);

            autoYokaiMinigameInterval = setInterval(async () => {
                try {
                    const res = await fetch('/api/bot/auto_yokai_minigame_step', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ 
                            sessionkey: sessionState.sessionkey,
                            char_id: sessionState.char_id
                        })
                    });
                    const data = await res.json();
                    addLog(`[Yokai Minigame] Response: ${data.message}`);
                    if (data.message && (data.message.toLowerCase().includes('failed') || data.message.toLowerCase().includes('energy') || data.message.toLowerCase().includes('ticket'))) {
                        btnAutoYokaiMinigame.click();
                    }
                } catch(e) {
                    addLog(`[Yokai Minigame] Error: ${e.message}`);
                }
            }, 5000);
        });
    }

    // Auto Shadow War
    let autoShadowWarInterval = null;
    const btnAutoShadowWar = document.getElementById('toggle-autoshadowwar');

    btnAutoShadowWar.addEventListener('click', () => {
        if (autoShadowWarInterval) {
            clearInterval(autoShadowWarInterval);
            autoShadowWarInterval = null;
            btnAutoShadowWar.textContent = "START";
            btnAutoShadowWar.style.background = "";
            addLog("Auto Shadow War STOPPED.");
            return;
        }

        btnAutoShadowWar.textContent = "STOP";
        btnAutoShadowWar.style.background = "#ff5252";
        addLog(`Auto Shadow War STARTED...`);

        autoShadowWarInterval = setInterval(async () => {
            try {
                const res = await fetch('/api/bot/auto_shadow_war_step', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ 
                        action: "shadow_war",
                        sessionkey: sessionState.sessionkey,
                        char_id: sessionState.char_id
                    })
                });
                const data = await res.json();
                addLog(`[AutoShadowWar] Response: ${data.message}`);
                // Stop immediately if it's not implemented on backend
                if (data.status === 'error') {
                    btnAutoShadowWar.click();
                }
            } catch(e) {
                addLog(`[AutoShadowWar] Error: ${e.message}`);
            }
        }, 5000);
    });

    // Auto Monster Hunt
    let autoMonsterInterval = null;
    const btnAutoMonster = document.getElementById('toggle-automonster');
    if (btnAutoMonster) {
        btnAutoMonster.addEventListener('click', () => {
            if (autoMonsterInterval) {
                clearInterval(autoMonsterInterval);
                autoMonsterInterval = null;
                btnAutoMonster.textContent = "START";
                btnAutoMonster.style.background = "";
                addLog("Auto Monster Hunt STOPPED.");
                return;
            }
            btnAutoMonster.textContent = "STOP";
            btnAutoMonster.style.background = "#ff5252";
            addLog("Auto Monster Hunt STARTED...");
            
            autoMonsterInterval = setInterval(async () => {
                try {
                    const res = await fetch('/api/bot/auto_monster_step', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ 
                            sessionkey: sessionState.sessionkey,
                            char_id: sessionState.char_id
                        })
                    });
                    const data = await res.json();
                    addLog(`[AutoMonster] Response: ${data.message}`);
                    if (data.status === 'error') btnAutoMonster.click();
                } catch(e) {
                    addLog(`[AutoMonster] Error: ${e.message}`);
                }
            }, 5000);
        });
    }

    // Auto Mission S
    let autoMissionSInterval = null;
    const btnAutoMissionS = document.getElementById('toggle-automissions');
    if (btnAutoMissionS) {
        btnAutoMissionS.addEventListener('click', () => {
            if (autoMissionSInterval) {
                clearInterval(autoMissionSInterval);
                autoMissionSInterval = null;
                btnAutoMissionS.textContent = "START";
                btnAutoMissionS.style.background = "";
                addLog("Auto Mission S STOPPED.");
                return;
            }
            btnAutoMissionS.textContent = "STOP";
            btnAutoMissionS.style.background = "#ff5252";
            addLog("Auto Mission S STARTED...");
            
            autoMissionSInterval = setInterval(async () => {
                try {
                    const res = await fetch('/api/bot/auto_mission_s_step', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ 
                            sessionkey: sessionState.sessionkey,
                            char_id: sessionState.char_id
                        })
                    });
                    const data = await res.json();
                    addLog(`[AutoMissionS] Response: ${data.message}`);
                    if (data.status === 'error') btnAutoMissionS.click();
                } catch(e) {
                    addLog(`[AutoMissionS] Error: ${e.message}`);
                }
            }, 5000);
        });
    }

    // Auto Clan War
    let autoClanWarInterval = null;
    const btnAutoClanWar = document.getElementById('toggle-autoclanwar');
    if (btnAutoClanWar) {
        btnAutoClanWar.addEventListener('click', () => {
            if (autoClanWarInterval) {
                clearInterval(autoClanWarInterval);
                autoClanWarInterval = null;
                btnAutoClanWar.textContent = "START";
                btnAutoClanWar.style.background = "";
                addLog("Auto Clan War STOPPED.");
                return;
            }
            btnAutoClanWar.textContent = "STOP";
            btnAutoClanWar.style.background = "#ff5252";
            addLog("Auto Clan War STARTED...");
            
            autoClanWarInterval = setInterval(async () => {
                try {
                    const res = await fetch('/api/bot/auto_clan_war_step', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ 
                            sessionkey: sessionState.sessionkey,
                            char_id: sessionState.char_id
                        })
                    });
                    const data = await res.json();
                    addLog(`[AutoClanWar] Response: ${data.message}`);
                    if (data.status === 'error') btnAutoClanWar.click();
                } catch(e) {
                    addLog(`[AutoClanWar] Error: ${e.message}`);
                }
            }, 5000);
        });
    }

    // Refresh Stats Button
    const btnRefreshStats = document.getElementById('btn-refresh-stats');
    if (btnRefreshStats) {
        btnRefreshStats.addEventListener('click', async () => {
            const stored = localStorage.getItem('ns_quick_login');
            if (stored) {
                addLog("Refreshing Session Token via Quick Login...");
                const creds = JSON.parse(stored);
                try {
                    const res = await fetch('/api/auth/login', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ username: creds.user, password: creds.pass })
                    });
                    const data = await res.json();
                    if (data.status === 'success') {
                        sessionState = {
                            sessionkey: data.sessionkey,
                            char_id: data.char_id,
                            char_name: data.char_name,
                            level: data.level || '--',
                            xp: data.xp || '--',
                            gold: data.gold || '--',
                            tokens: data.tokens || '--'
                        };
                        localStorage.setItem('ns_session', JSON.stringify(sessionState));
                        addLog("Session refreshed successfully! ✅");
                        checkLoginState();
                    } else {
                        const errMsg = data.message || (data.detail ? JSON.stringify(data.detail) : "Unknown error");
                        addLog("Failed to refresh session: " + errMsg, "err");
                    }
                } catch(e) {
                    addLog("Error refreshing session: " + e.message, "err");
                }
            } else {
                addLog("No quick login credentials found. Please logout and login manually.", "err");
            }
        });
    }

    // Initial check
    checkLoginState();
});

// Settings Logic
window.loadSettings = async function() {
    try {
        const res = await fetch('/api/bot/settings');
        const data = await res.json();
        if (data.status === 'success' && data.settings) {
            document.getElementById('setting-leveling-delay').value = data.settings.leveling_delay_seconds || 10;
            document.getElementById('setting-shadow-wait').value = data.settings.sage_shadow_war_wait_minutes || 30;
            document.getElementById('setting-clan-token').checked = !!data.settings.clan_war_auto_spend_token;
            document.getElementById('setting-clan-refill').value = data.settings.clan_war_stamina_refill_source || 'auto';
        }
    } catch(e) {
        console.error("Error loading settings:", e);
    }
}

window.saveSettings = async function() {
    try {
        const payload = {
            leveling_delay_seconds: parseInt(document.getElementById('setting-leveling-delay').value) || 10,
            sage_shadow_war_wait_minutes: parseInt(document.getElementById('setting-shadow-wait').value) || 30,
            clan_war_auto_spend_token: document.getElementById('setting-clan-token').checked,
            clan_war_stamina_refill_source: document.getElementById('setting-clan-refill').value
        };
        const res = await fetch('/api/bot/settings', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        });
        const data = await res.json();
        if (data.status === 'success') {
            alert('Settings saved successfully!');
            document.getElementById('modal-settings').classList.remove('show');
        } else {
            alert('Failed to save settings: ' + data.message);
        }
    } catch(e) {
        alert("Error saving settings: " + e.message);
    }
}

// Auto-Mission Farmer
let autoMissionInterval = null;
document.getElementById('toggle-automission-farmer').addEventListener('click', () => {
    const btn = document.getElementById('toggle-automission-farmer');
    const missionIdInput = document.getElementById('auto_mission_id');
    const targetMissionId = missionIdInput.value.trim();
    
    if (!targetMissionId) {
        addLog("[AutoMission] Error: Please enter a valid mission ID (e.g. msn_11 or auto).", "error");
        return;
    }
    
    if (autoMissionInterval) {
        clearInterval(autoMissionInterval);
        autoMissionInterval = null;
        btn.textContent = "START";
        btn.style.background = "";
        missionIdInput.disabled = false;
        addLog("Auto-Mission Farmer STOPPED.");
        return;
    }
    
    btn.textContent = "STOP";
    btn.style.background = "#ff5252";
    missionIdInput.disabled = true;
    addLog(`Auto-Mission Farmer STARTED for mission: ${targetMissionId}...`);
    
    autoMissionInterval = setInterval(async () => {
        try {
            const res = await fetch('/api/bot/auto_mission_step', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    sessionkey: sessionState.sessionkey,
                    char_id: sessionState.char_id,
                    mission_id: targetMissionId
                })
            });
            const data = await res.json();
            
            if (data.status === 'success' && !data.message.includes("Failed")) {
                addLog(`[AutoMission] Success: ${data.message}`);
            } else {
                addLog(`[AutoMission] Response: ${data.message || data.status}`);
                // Stop automatically if it fails heavily (e.g. invalid mission)
                if (data.message && data.message.includes('Invalid response')) {
                    btn.click();
                }
            }
        } catch(e) {
            addLog(`[AutoMission] Error: ${e.message}`);
        }
    }, 4000); // 4 seconds delay
});
