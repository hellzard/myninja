(() => {
  'use strict';

  const DRAFT_KEY = 'ns_recipe_draft_v51';
  const bots = [
    ['auto_level', 'Auto Leveling'], ['auto_daily', 'Auto Daily'],
    ['auto_hunting', 'Auto Hunting'], ['eudemon', 'Eudemon'],
    ['circus', 'Circus'], ['yokai', 'Yokai'], ['yokai_minigame', 'Yokai Minigame'],
    ['shadow_war', 'Shadow War'], ['monster', 'Monster Hunter'],
    ['mission_s', 'Mission S'], ['clan_war', 'Clan War'], ['mission', 'Mission Farmer'],
  ];

  function creds() {
    try {
      const value = JSON.parse(sessionStorage.getItem('ns_quick_login') || 'null');
      return value?.user && value?.pass ? { username: value.user, password: value.pass } : null;
    } catch (_) { return null; }
  }
  function optionMarkup() {
    return bots.map(([value, label]) => `<option value="${value}">${label}</option>`).join('');
  }
  function refreshRow(row) {
    const kind = row.querySelector('.rs-kind').value;
    const bot = row.querySelector('.rs-bot').value;
    const mode = row.querySelector('.rs-mode');
    const value = row.querySelector('.rs-value');
    const mission = row.querySelector('.rs-mission');
    const isWait = kind === 'wait';

    row.querySelector('.rs-bot').classList.toggle('hidden', isWait);
    mode.classList.toggle('hidden', isWait);
    mission.classList.toggle('hidden', isWait || bot !== 'mission');

    const levelOption = [...mode.options].find(o => o.value === 'level_at_least');
    if (levelOption) levelOption.disabled = bot !== 'auto_level';
    if (bot !== 'auto_level' && mode.value === 'level_at_least') mode.value = 'cycles';

    value.min = 1;
    value.max = isWait ? 86400 : (mode.value === 'level_at_least' ? 200 : 5000);
    value.placeholder = isWait ? 'Seconds' : (mode.value === 'level_at_least' ? 'Target level' : 'Cycles / cap');
  }
  function stepRow(initial = {}) {
    const row = document.createElement('div');
    row.className = 'ns-recipe-step';
    row.innerHTML = `
      <select class="input-field rs-kind"><option value="bot">Bot</option><option value="wait">Wait</option></select>
      <select class="input-field rs-bot">${optionMarkup()}</select>
      <select class="input-field rs-mode">
        <option value="cycles">Cycles</option><option value="until_stop">Until completed</option><option value="level_at_least">Until level ≥</option>
      </select>
      <input class="input-field rs-value" type="number" min="1" value="5">
      <input class="input-field rs-mission hidden" type="text" maxlength="80" placeholder="Mission ID (e.g. msn_60)">
      <div class="rs-actions">
        <button class="btn btn-toggle rs-up" type="button" title="Move up">↑</button>
        <button class="btn btn-toggle rs-down" type="button" title="Move down">↓</button>
        <button class="btn btn-toggle rs-remove" type="button" title="Remove"><i class="fa-solid fa-xmark"></i></button>
      </div>`;

    row.querySelector('.rs-kind').value = initial.kind || 'bot';
    row.querySelector('.rs-bot').value = initial.bot_type || 'auto_level';
    row.querySelector('.rs-mode').value = initial.mode || 'cycles';
    row.querySelector('.rs-value').value = initial.kind === 'wait'
      ? (initial.seconds || 5)
      : (initial.mode === 'level_at_least' ? (initial.target_level || 80) : (initial.cycles || initial.max_cycles || 5));
    row.querySelector('.rs-mission').value = initial.params?.mission_id || '';

    for (const cls of ['.rs-kind', '.rs-bot', '.rs-mode']) {
      row.querySelector(cls).onchange = () => { refreshRow(row); saveDraft(); };
    }
    row.querySelector('.rs-value').oninput = saveDraft;
    row.querySelector('.rs-mission').oninput = saveDraft;
    row.querySelector('.rs-remove').onclick = () => { row.remove(); saveDraft(); };
    row.querySelector('.rs-up').onclick = () => {
      const previous = row.previousElementSibling;
      if (previous) row.parentElement.insertBefore(row, previous);
      saveDraft();
    };
    row.querySelector('.rs-down').onclick = () => {
      const next = row.nextElementSibling;
      if (next) row.parentElement.insertBefore(next, row);
      saveDraft();
    };
    refreshRow(row);
    return row;
  }
  function collect() {
    const steps = [...document.querySelectorAll('.ns-recipe-step')].map(row => {
      const kind = row.querySelector('.rs-kind').value;
      const raw = Math.max(1, parseInt(row.querySelector('.rs-value').value || '1', 10));
      if (kind === 'wait') return { kind: 'wait', seconds: Math.max(5, raw), label: 'Wait' };
      const bot = row.querySelector('.rs-bot').value;
      const mode = row.querySelector('.rs-mode').value;
      const params = {};
      if (bot === 'mission') params.mission_id = row.querySelector('.rs-mission').value.trim();
      return {
        kind: 'bot', bot_type: bot, mode,
        cycles: mode === 'cycles' ? raw : 1,
        target_level: mode === 'level_at_least' ? raw : null,
        max_cycles: mode === 'cycles' ? raw : (mode === 'level_at_least' ? 500 : Math.min(5000, raw || 500)),
        params,
      };
    });
    return { name: (document.getElementById('recipe-name')?.value || 'Automation Recipe').trim(), steps };
  }
  function saveDraft() {
    try { localStorage.setItem(DRAFT_KEY, JSON.stringify(collect())); } catch (_) {}
  }
  function loadDraft() {
    try { return JSON.parse(localStorage.getItem(DRAFT_KEY) || 'null'); } catch (_) { return null; }
  }
  async function dryRun() {
    const response = await fetch('/api/bot/recipe/dry-run', {
      method: 'POST', headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ recipe: collect() }),
    });
    const data = await response.json();
    if (!response.ok) throw new Error(data.detail || `HTTP ${response.status}`);
    return data.dry_run;
  }
  function renderDryRun(result) {
    const host = document.getElementById('recipe-dry-result');
    if (!host) return;
    const outline = (result.outline || []).map(step =>
      `<li><strong>${step.index}. ${step.label}</strong> · ${window.NinjaUI?.formatDuration?.(step.estimate_seconds) || step.estimate_seconds + 's'}${step.bounded ? '' : ' · safety cap'}</li>`
    ).join('');
    const warnings = (result.warnings || []).map(x => `<li>${x}</li>`).join('');
    host.innerHTML = `
      <strong>Estimate: ${window.NinjaUI?.formatDuration?.(result.estimate_seconds) || result.estimate_seconds + 's'}</strong>
      · cycle budget ${result.cycle_budget || 0}/5000
      <ol>${outline}</ol>
      ${warnings ? `<div class="ns-recipe-warnings"><strong>Notes</strong><ul>${warnings}</ul></div>` : ''}`;
  }
  function ensure() {
    if (document.getElementById('modal-recipes')) return;
    const scheduler = document.getElementById('btn-scheduler') || document.getElementById('btn-settings');
    if (!scheduler) return;

    const btn = document.createElement('button');
    btn.id = 'btn-recipes'; btn.className = 'btn btn-toggle'; btn.title = 'Automation Studio';
    btn.innerHTML = '<i class="fa-solid fa-wand-magic-sparkles"></i>';
    scheduler.insertAdjacentElement('afterend', btn);

    const modal = document.createElement('div');
    modal.id = 'modal-recipes'; modal.className = 'modal-overlay';
    modal.innerHTML = `
      <div class="modal-content glass-panel ns-recipe-modal">
        <div class="modal-header"><h3><i class="fa-solid fa-wand-magic-sparkles"></i> Automation Studio</h3><button class="btn-close" type="button">&times;</button></div>
        <div class="input-wrapper"><label>Recipe name</label><input id="recipe-name" class="input-field" value="Daily + Leveling"></div>
        <div id="recipe-steps" class="ns-recipe-steps"></div>
        <button id="recipe-add" class="btn btn-toggle" type="button">+ Add step</button>
        <div class="ns-recipe-schedule">
          <label>Start at (optional)<input id="recipe-at" type="datetime-local" class="input-field"></label>
          <label>Repeat<select id="recipe-repeat" class="input-field"><option value="0">Once</option><option value="21600">6 hours</option><option value="43200">12 hours</option><option value="86400">Daily</option></select></label>
        </div>
        <div id="recipe-dry-result" class="ns-recipe-note">Dry-run belum dijalankan.</div>
        <div class="ns-recipe-actions ns-sticky-actions"><button id="recipe-dry" class="btn btn-toggle" type="button">Dry Run</button><button id="recipe-start" class="btn btn-primary" type="button">Start Recipe</button></div>
      </div>`;
    document.body.appendChild(modal);

    const steps = modal.querySelector('#recipe-steps');
    const draft = loadDraft();
    if (draft?.steps?.length) {
      document.getElementById('recipe-name').value = draft.name || 'Automation Recipe';
      draft.steps.forEach(step => steps.append(stepRow(step)));
    } else {
      steps.append(
        stepRow({ kind: 'bot', bot_type: 'auto_daily', mode: 'until_stop', max_cycles: 100 }),
        stepRow({ kind: 'bot', bot_type: 'auto_level', mode: 'level_at_least', target_level: 80, max_cycles: 500 }),
      );
    }

    document.getElementById('recipe-name').addEventListener('input', saveDraft);
    btn.onclick = () => modal.classList.add('show');
    modal.querySelector('.btn-close').onclick = () => modal.classList.remove('show');
    modal.querySelector('#recipe-add').onclick = () => {
      if (steps.children.length >= 20) return window.NinjaUI?.toast('Maksimal 20 step.', 'warn');
      steps.append(stepRow()); saveDraft();
    };
    modal.querySelector('#recipe-dry').onclick = async () => {
      try { renderDryRun(await dryRun()); }
      catch (error) { window.NinjaUI?.toast(`Dry-run gagal: ${error.message}`, 'error'); }
    };
    modal.querySelector('#recipe-start').onclick = async () => {
      const s = window.NinjaSession?.get?.();
      if (!s?.sessionkey) return window.NinjaUI?.toast('Login terlebih dahulu.', 'warn');
      try {
        renderDryRun(await dryRun());
        saveDraft();
        const params = { recipe: collect() };
        const rawAt = document.getElementById('recipe-at').value;
        if (rawAt) {
          const date = new Date(rawAt);
          if (Number.isNaN(date.getTime()) || date.getTime() < Date.now() + 30000) throw new Error('Waktu start harus di masa depan.');
          params.schedule_at = Math.floor(date.getTime() / 1000);
        }
        const repeat = parseInt(document.getElementById('recipe-repeat').value || '0', 10) || 0;
        if (repeat) params.repeat_every_seconds = repeat;

        const response = await fetch('/api/bot/cloud/start', {
          method: 'POST', headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ sessionkey: s.sessionkey, char_id: s.char_id, bot_type: 'recipe', params, credentials: creds() }),
        });
        const data = await response.json();
        if (!response.ok) throw new Error(data.detail || `HTTP ${response.status}`);

        localStorage.setItem(`ns_cloud_control_${s.char_id}`, JSON.stringify({ char_id: s.char_id, token: data.job.control_token, bot_type: 'recipe' }));
        modal.classList.remove('show');
        window.dispatchEvent(new CustomEvent('ns:cloud-control'));
        window.dispatchEvent(new CustomEvent('ns:cloud-status', { detail: data.job }));
        window.NinjaRealtime?.connect?.();
      } catch (error) {
        window.NinjaUI?.toast(`Recipe gagal: ${error.message}`, 'error');
      }
    };
  }

  document.addEventListener('DOMContentLoaded', ensure);
  window.NinjaRecipes = { collect, dryRun };
})();