(() => {
  'use strict';
  let nextActionAt = null;
  function ensurePanel(){
    if(document.getElementById('ns-analytics'))return; const status=document.getElementById('bot-status-text'); if(!status)return;
    const panel=document.createElement('section'); panel.id='ns-analytics'; panel.className='ns-analytics'; panel.innerHTML=`
      <div class="ns-health-row"><span id="ns-health-badge" class="ns-health-badge" data-state="IDLE">IDLE</span><span id="ns-health-detail" class="ns-health-detail">No active cloud job</span><span id="ns-next-action" class="ns-next-action"></span></div>
      <div class="ns-metric-grid ns-metric-grid-pro">
        <div class="ns-mini-stat"><small>XP / hour</small><strong id="ns-xph">0</strong></div><div class="ns-mini-stat"><small>Gold / hour</small><strong id="ns-gph">0</strong></div>
        <div class="ns-mini-stat"><small>Success</small><strong id="ns-success">0</strong></div><div class="ns-mini-stat"><small>Success rate</small><strong id="ns-success-rate">0%</strong></div>
        <div class="ns-mini-stat"><small>Actions / hour</small><strong id="ns-aph">0</strong></div><div class="ns-mini-stat"><small>p95 latency</small><strong id="ns-latency">0 ms</strong></div>
        <div class="ns-mini-stat"><small>Effective delay</small><strong id="ns-delay">--</strong></div><div class="ns-mini-stat"><small>Relogin / Rate limit</small><strong id="ns-recovery">0 / 0</strong></div>
        <div class="ns-mini-stat"><small>Uptime</small><strong id="ns-uptime">0s</strong></div><div class="ns-mini-stat"><small>Target ETA</small><strong id="ns-eta">Learning…</strong></div>
      </div>`; status.insertAdjacentElement('afterend',panel);
  }
  const num=v=>Math.round(Number(v)||0).toLocaleString();
  async function eta(job){
    const el=document.getElementById('ns-eta'); if(!el)return; const target=Number(job?.params?.max_level); const s=window.NinjaSession?.get?.(); const level=Number(s?.level);
    if(!target||!level||target<=level){el.textContent=target&&target<=level?'Reached':'—';return;}
    const samples=await window.NinjaHistory?.levelSamples?.(s.char_id,100) || []; if(samples.length<2){el.textContent='Learning…';return;}
    const newest=samples[0], oldest=samples[samples.length-1]; const dl=Number(newest.data.level)-Number(oldest.data.level); const hours=(newest.ts-oldest.ts)/3600;
    if(dl<=0||hours<0.02){el.textContent='Learning…';return;} const lph=dl/hours; el.textContent=window.NinjaUI?.formatDuration?.(((target-level)/lph)*3600)||'Learning…';
  }
  async function render(job={}){ensurePanel(); const h=job.health||{},a=job.analytics||{}; const state=String(h.state||(job.running?'RUNNING':'IDLE')).toUpperCase();
    const badge=document.getElementById('ns-health-badge'); if(badge){badge.textContent=state.replaceAll('_',' ');badge.dataset.state=state;} const detail=document.getElementById('ns-health-detail'); if(detail)detail.textContent=h.detail||job.last_message||'No active cloud job';
    const values={'ns-xph':num(a.xp_per_hour),'ns-gph':num(a.gold_per_hour),'ns-success':num(a.success_count),'ns-success-rate':`${Number(a.success_rate||0).toFixed(1)}%`,'ns-aph':num(a.actions_per_hour),'ns-latency':`${num(a.network_p95_ms)} ms`,'ns-delay':a.pacing_effective_seconds?`${Number(a.pacing_effective_seconds).toFixed(1)}s`:'--','ns-recovery':`${num(a.relogin_count)} / ${num(a.rate_limit_count)}`,'ns-uptime':window.NinjaUI?.formatDuration?.(a.uptime_seconds||0)||'0s'};
    for(const [id,v] of Object.entries(values)){const el=document.getElementById(id);if(el)el.textContent=v;} nextActionAt=Number(h.next_action_at)||null; eta(job);
  }
  setInterval(()=>{const el=document.getElementById('ns-next-action');if(!el)return;if(!nextActionAt){el.textContent='';return;}const remaining=nextActionAt-Date.now()/1000;el.textContent=remaining>0?`Next: ${window.NinjaUI?.formatDuration?.(remaining)||Math.ceil(remaining)+'s'}`:'Next: now';},1000);
  window.addEventListener('ns:cloud-status',e=>render(e.detail||{})); document.addEventListener('DOMContentLoaded',ensurePanel);
})();
