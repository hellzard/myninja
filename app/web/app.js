document.addEventListener('DOMContentLoaded', () => {
    const loginModal = document.getElementById('auth-view');
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

    function addLog(msg, type = "info") {
        const li = document.createElement('li');
        li.className = 'log-entry';
        
        const now = new Date();
        const timeStr = now.getHours().toString().padStart(2, '0') + ':' + now.getMinutes().toString().padStart(2, '0') + ':' + now.getSeconds().toString().padStart(2, '0');
        
        const timeSpan = document.createElement('div');
        timeSpan.className = 'log-time';
        timeSpan.textContent = timeStr;
        
        const dot = document.createElement('div');
        dot.className = 'log-dot ' + (type === 'error' ? 'err' : 'ok');
        
        const msgDiv = document.createElement('div');
        msgDiv.className = 'log-msg ' + (type === 'error' ? 'error' : '');
        msgDiv.textContent = msg;
        
        li.appendChild(timeSpan);
        li.appendChild(dot);
        li.appendChild(msgDiv);
        
        activityLog.appendChild(li); // append at bottom
        
        const terminalWindow = document.getElementById('terminal-window');
        if (terminalWindow) {
            terminalWindow.scrollTop = terminalWindow.scrollHeight;
        }
        
        if (activityLog.children.length > 100) {
            activityLog.removeChild(activityLog.firstChild);
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
        if(confirm("Are you sure you want to logout? All running bots will be stopped.")) {
            localStorage.removeItem('ns_session');
            window.location.reload();
        }
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
                    if (stopGlobalBtn) stopGlobalBtn.classList.remove("hidden");
                } else {
                    if (currentRunningBotBtn === this) {
                        currentRunningBotBtn = null;
                        if (statusText) {
                            statusText.textContent = "Idle - No bot is currently running.";
                            statusText.style.color = "#eee";
                        }
                        if (stopGlobalBtn) stopGlobalBtn.classList.add("hidden");
                    }
                }
            }, 10);
        });
    });
    
    // Auto Leveling
    let autoLevelIsRunning = false;
    let autoLevelTarget = 0;
    const btnAutoLevel = document.getElementById('toggle-autolevel');
    
    btnAutoLevel.addEventListener('click', () => {
        if (autoLevelIsRunning) {
            autoLevelIsRunning = false;
            btnAutoLevel.textContent = "START";
            btnAutoLevel.style.background = "";
            addLog("Auto Leveling STOPPED.");
            return;
        }
        
        btnAutoLevel.textContent = "STOP";
        btnAutoLevel.style.background = "#ff5252";
        
        let charLevel = parseInt(sessionState.level);
        if (isNaN(charLevel)) charLevel = 1;
        
        let targetMissionId = "msn_11"; // Grade C
        if (charLevel >= 40) targetMissionId = "msn_42"; // Sannin
        else if (charLevel >= 20) targetMissionId = "msn_23"; // Grade A
        else if (charLevel >= 10) targetMissionId = "msn_18"; // Grade B
        
        autoLevelTarget = targetMissionId;
        autoLevelIsRunning = true;
        
        addLog(`Auto Leveling STARTED (Targeting ${autoLevelTarget} based on Character Level ${charLevel})...`);
        
        async function runLoop() {
            if (!autoLevelIsRunning) return;
            
            if (!autoLevelTarget) {
                addLog("Invalid mission level. Stopping.");
                btnAutoLevel.click();
                return;
            }
            
            let delay = 4000;
            
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
            
            if (!autoLevelIsRunning) return;
            
            // Then run normal leveling
            try {
                const res = await fetch('/api/bot/auto_leveling_step', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        sessionkey: sessionState.sessionkey,
                        char_id: sessionState.char_id,
                        mission_id: autoLevelTarget
                    })
                });
                const data = await res.json();
                if (data.status === 'success' && !data.message.includes("Failed")) {
                    addLog(`[AutoLevel] ${autoLevelTarget} Success: ${data.message}`);
                } else {
                    addLog(`[AutoLevel] ${autoLevelTarget} Response: ${data.message}`);
                    if (data.message.includes("rate limited")) {
                        addLog("[System] Rate limit detected. Backing off for 10 seconds...", "warn");
                        delay = 10000;
                    }
                }
            } catch(e) {
                addLog(`[AutoLevel] Error: ${e.message}`);
            }
            
            if (autoLevelIsRunning) {
                setTimeout(runLoop, delay);
            }
        }
        
        runLoop();
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
        }, 4000);
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
        }, 4000); // 4 seconds delay for boss fights
    });

    // Eudemon Boss (Desktop & Mobile share same logic if we use querySelectorAll)
        const eudemonBtns = document.querySelectorAll('#btnAutoEudemon');
    let autoEudemonInterval = null;
    
    eudemonBtns.forEach(btn => {
        btn.addEventListener('click', async () => {
            if (!sessionState.sessionkey) return;
            
            if (autoEudemonInterval) {
                clearInterval(autoEudemonInterval);
                autoEudemonInterval = null;
                btn.textContent = "START";
                btn.style.background = ""; // reset color
                addLog(`Auto Eudemon STOPPED.`);
                return;
            }
            
            btn.textContent = "STOP";
            btn.style.background = "#ff5252";
            addLog(`Auto Eudemon STARTED...`);
            
            autoEudemonInterval = setInterval(async () => {
                try {
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
                        addLog(`[Eudemon] ${data.message}`, 'ok');
                        if (data.message.includes("No available Eudemon bosses")) {
                            btn.click();
                        }
                    } else {
                        addLog(`[Eudemon] Failed: ${data.message}`, 'error');
                        btn.click();
                    }
                } catch (e) {
                    addLog(`[Eudemon] Error: ${e.message}`, 'error');
                    btn.click();
                }
            }, 4000);
        });
    });


    // Circus Event
    let autoCircusInterval = null;
    const btnAutoCircus = document.getElementById('toggle-autocircus');

    if (btnAutoCircus) {
        btnAutoCircus.addEventListener('click', () => {
            const bossId = document.getElementById('circus-boss-id').value;
            const eventIdStr = bossId === 'ringmaster' ? 'circus_ringmaster' : 'circus_jester';
            const bossName = bossId === 'ringmaster' ? 'Ringmaster' : 'Jester';

            if (autoCircusInterval) {
                clearInterval(autoCircusInterval);
                autoCircusInterval = null;
                btnAutoCircus.textContent = "START";
                btnAutoCircus.style.background = "";
                addLog(`Auto Circus ${bossName} STOPPED.`);
                return;
            }

            btnAutoCircus.textContent = "STOP";
            btnAutoCircus.style.background = "#ff5252";
            addLog(`Auto Circus ${bossName} STARTED...`);

            autoCircusInterval = setInterval(async () => {
                try {
                    const res = await fetch('/api/bot/auto_event_step', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ 
                            sessionkey: sessionState.sessionkey,
                            char_id: sessionState.char_id,
                            event_id: eventIdStr
                        })
                    });
                    const data = await res.json();
                    addLog(`[Circus ${bossName}] Response: ${data.message}`);
                    if (data.message && (data.message.toLowerCase().includes('failed') || data.message.toLowerCase().includes('energy') || data.message.toLowerCase().includes('ticket') || data.message.toLowerCase().includes('stopped'))) {
                        btnAutoCircus.click();
                    }
                } catch(e) {
                    addLog(`[Circus ${bossName}] Error: ${e.message}`);
                }
            }, 4000);
        });
    }

    // Yokai Event
    let autoYokaiInterval = null;
    const btnAutoYokai = document.getElementById('toggle-autoyokai');

    if (btnAutoYokai) {
        btnAutoYokai.addEventListener('click', () => {
            const bossId = document.getElementById('yokai-boss-id').value;
            let eventIdStr = 'yokai_kitsune';
            let bossName = 'Kitsune';
            if (bossId === 'tengu') {
                eventIdStr = 'yokai_tengu'; bossName = 'Tengu';
            } else if (bossId === 'nurarihyon') {
                eventIdStr = 'yokai_nurarihyon'; bossName = 'Nurarihyon';
            }

            if (autoYokaiInterval) {
                clearInterval(autoYokaiInterval);
                autoYokaiInterval = null;
                btnAutoYokai.textContent = "START";
                btnAutoYokai.style.background = "";
                addLog(`Auto Yokai ${bossName} STOPPED.`);
                return;
            }

            btnAutoYokai.textContent = "STOP";
            btnAutoYokai.style.background = "#ff5252";
            addLog(`Auto Yokai ${bossName} STARTED...`);

            autoYokaiInterval = setInterval(async () => {
                try {
                    const res = await fetch('/api/bot/auto_event_step', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ 
                            sessionkey: sessionState.sessionkey,
                            char_id: sessionState.char_id,
                            event_id: eventIdStr
                        })
                    });
                    const data = await res.json();
                    addLog(`[Yokai ${bossName}] Response: ${data.message}`);
                    if (data.message && (data.message.toLowerCase().includes('failed') || data.message.toLowerCase().includes('energy') || data.message.toLowerCase().includes('ticket') || data.message.toLowerCase().includes('stopped'))) {
                        btnAutoYokai.click();
                    }
                } catch(e) {
                    addLog(`[Yokai ${bossName}] Error: ${e.message}`);
                }
            }, 4000);
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
            }, 4000);
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
        }, 4000);
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
            }, 4000);
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
            }, 4000);
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
            }, 4000);
        });
    }

    // Refresh Stats Logic
    async function refreshStats(quiet = false) {
        if (!sessionState || !sessionState.sessionkey) return;
        try {
            const res = await fetch('/api/bot/get_stats', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ 
                    sessionkey: sessionState.sessionkey,
                    char_id: sessionState.char_id
                })
            });
            const data = await res.json();
            if (data.status === 'success') {
                sessionState.gold = data.gold;
                sessionState.xp = data.xp;
                sessionState.level = data.level;
                sessionState.tokens = data.tokens;
                
                localStorage.setItem('ns_session', JSON.stringify(sessionState));
                checkLoginState();
                if (!quiet) addLog("Stats refreshed successfully! ✅");
            } else {
                if (!quiet) addLog("Failed to refresh stats: " + data.message, "err");
            }
        } catch(e) {
            if (!quiet) addLog("Error refreshing stats: " + e.message, "err");
        }
    }

    const btnRefreshStats = document.getElementById('btn-refresh-stats');
    if (btnRefreshStats) {
        btnRefreshStats.addEventListener('click', () => {
            addLog("Refreshing Character Stats...");
            refreshStats();
        });
    }

    // Auto update stats every 5 seconds if a bot is running
    setInterval(() => {
        const statusTextStr = statusText ? statusText.textContent : "";
        if (statusTextStr.includes("Running")) {
            refreshStats(true); // quiet refresh
        }
    }, 5000);

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

// ==========================================
// BACKGROUND CANVAS PARTICLES (Cyber-Ninja)
// ==========================================
const canvas = document.getElementById('canvas-bg');
if (canvas) {
    const ctx = canvas.getContext('2d');
    let width, height;
    let particles = [];
    
    function resize() {
        width = window.innerWidth;
        height = window.innerHeight;
        // On mobile, draw at half resolution to save GPU
        let dpr = (width <= 768) ? 0.5 : 1;
        canvas.width = width * dpr;
        canvas.height = height * dpr;
        ctx.scale(dpr, dpr);
    }
    window.addEventListener('resize', resize);
    resize();
    
    class Particle {
        constructor() {
            this.x = Math.random() * width;
            this.y = Math.random() * height;
            this.size = Math.random() * 2 + 0.5;
            this.speedX = Math.random() * 1 - 0.5;
            this.speedY = Math.random() * -1 - 0.5; // Float upwards
            this.color = Math.random() > 0.5 ? 'rgba(234, 88, 12, ' : 'rgba(251, 191, 36, ';
            this.alpha = Math.random() * 0.5 + 0.1;
        }
        update() {
            this.x += this.speedX;
            this.y += this.speedY;
            if (this.y < 0) {
                this.y = height;
                this.x = Math.random() * width;
            }
            if (this.x < 0 || this.x > width) {
                this.speedX *= -1;
            }
        }
        draw() {
            ctx.fillStyle = this.color + this.alpha + ')';
            ctx.beginPath();
            ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
            ctx.fill();
        }
    }
    
    let numParticles = (window.innerWidth <= 768) ? 20 : 50;
    for (let i = 0; i < numParticles; i++) {
        particles.push(new Particle());
    }
    
    let lastTime = 0;
    function animate(timestamp) {
        requestAnimationFrame(animate);
        
        // Limit FPS to 30 on mobile
        if (window.innerWidth <= 768) {
            if (timestamp - lastTime < 33) return; 
        }
        lastTime = timestamp;
        
        ctx.clearRect(0, 0, width, height);
        particles.forEach(p => {
            p.update();
            p.draw();
        });
    }
    
    requestAnimationFrame(animate);
}

// ----------------------------------------------------
// TOP SECRET MODULE (GACHA EXPLOIT)
// ----------------------------------------------------

let secretUnlocked = false;

function openSecretModal() {
    if (!secretUnlocked) {
        document.getElementById('modal-password').classList.add('show');
    } else {
        document.getElementById('modal-secret').classList.add('show');
    }
}

function verifySecretPassword() {
    const input = document.getElementById('secret_passcode').value;
    if (input === 'adiganteng') {
        secretUnlocked = true;
        document.getElementById('secret_passcode').value = '';
        document.getElementById('modal-password').classList.remove('show');
        document.getElementById('modal-secret').classList.add('show');
        addLog("[System] Exploit Arsenal Unlocked. Proceed with caution.", "success");
    } else {
        alert("ACCESS DENIED");
        document.getElementById('secret_passcode').value = '';
    }
}

async function triggerGachaExploit() {
    const sessionkey = document.getElementById("sessionkey").value;
    const char_id = document.getElementById("char_id").value;
    const coinType = document.getElementById("exploit_coin_type").value;
    const spamCount = parseInt(document.getElementById("exploit_spam_count").value, 10);

    if (!sessionkey || !char_id) {
        alert("Please login first!");
        return;
    }

    const btn = document.getElementById("btn-exploit-gacha");
    btn.innerText = "EXECUTING...";
    btn.disabled = true;
    addLog(`[Gacha Exploit] Initiating Race Condition: ${spamCount}x ${coinType}...`, "warning");

    try {
        const response = await fetch("/api/bot/exploit_gacha", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                sessionkey: sessionkey,
                char_id: parseInt(char_id),
                coin_type: coinType,
                spam_count: spamCount
            })
        });
        const data = await response.json();
        if (data.status === "success") {
            addLog(`[Gacha Exploit] Success: ${data.message}`, "success");
        } else {
            addLog(`[Gacha Exploit] Error: ${data.message}`, "error");
        }
    } catch(e) {
        addLog(`[Gacha Exploit] Network Error: ${e.message}`, "error");
    } finally {
        btn.innerText = "EXECUTE";
        btn.disabled = false;
    }
}

