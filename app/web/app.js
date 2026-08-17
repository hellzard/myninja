(() => {
  'use strict';

  function session() {
    return window.NinjaSession?.get?.() || null;
  }

  async function runCommand(button) {
    const current = session();
    if (!current?.sessionkey || !current?.char_id) {
      window.NinjaUI?.toast('Login terlebih dahulu.', 'warn');
      return;
    }

    const action = button.dataset.action;
    if (!action) return;
    const params = {};
    if (action === 'mission') {
      const missionId = document.getElementById('mission_id')?.value?.trim();
      if (!missionId) return window.NinjaUI?.toast('Mission ID belum diisi.', 'warn');
      params.mission_id = missionId;
    } else if (action === 'hunting') {
      const zone = parseInt(document.getElementById('hunting_zone')?.value || '0', 10);
      if (!zone) return window.NinjaUI?.toast('Hunting zone belum dipilih.', 'warn');
      params.zone = zone;
    }

    button.disabled = true;
    try {
      const response = await fetch('/api/bot/command', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        cache: 'no-store',
        body: JSON.stringify({
          action,
          sessionkey: current.sessionkey,
          char_id: current.char_id,
          params,
        }),
      });
      const data = await response.json();
      if (!response.ok || data.status !== 'success') {
        throw new Error(data.message || data.detail || `HTTP ${response.status}`);
      }
      window.NinjaUI?.log(`Success: ${data.result}`, 'info');
    } catch (error) {
      window.NinjaUI?.log(`Command error: ${error.message}`, 'error');
    } finally {
      button.disabled = false;
    }
  }

  function initCommands() {
    document.querySelectorAll('.cmd-btn[data-action]').forEach(button => {
      button.addEventListener('click', () => runCommand(button));
    });
  }

  function initDesktopCanvas() {
    const canvas = document.getElementById('canvas-bg');
    if (!canvas) return;
    const mobile = window.innerWidth <= 768 || window.matchMedia('(pointer: coarse)').matches;
    if (mobile) {
      canvas.style.display = 'none';
      return;
    }

    const ctx = canvas.getContext('2d');
    if (!ctx) return;
    let width = 0, height = 0, raf = null;
    const particles = Array.from({ length: 28 }, () => ({
      x: 0, y: 0, size: Math.random() * 1.5 + 0.5,
      sx: Math.random() * .6 - .3, sy: Math.random() * -.6 - .15,
      alpha: Math.random() * .35 + .08,
    }));

    function resize() {
      width = innerWidth; height = innerHeight;
      const dpr = Math.min(devicePixelRatio || 1, 1.5);
      canvas.width = Math.floor(width * dpr);
      canvas.height = Math.floor(height * dpr);
      canvas.style.width = `${width}px`;
      canvas.style.height = `${height}px`;
      ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
      particles.forEach(p => {
        if (!p.x) p.x = Math.random() * width;
        if (!p.y) p.y = Math.random() * height;
      });
    }

    function frame() {
      if (document.hidden) return;
      ctx.clearRect(0, 0, width, height);
      for (const p of particles) {
        p.x += p.sx; p.y += p.sy;
        if (p.y < -5) { p.y = height + 5; p.x = Math.random() * width; }
        if (p.x < 0 || p.x > width) p.sx *= -1;
        ctx.fillStyle = `rgba(234,88,12,${p.alpha})`;
        ctx.beginPath(); ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2); ctx.fill();
      }
      raf = requestAnimationFrame(frame);
    }

    addEventListener('resize', resize, { passive: true });
    document.addEventListener('visibilitychange', () => {
      if (document.hidden && raf) cancelAnimationFrame(raf);
      else if (!document.hidden) raf = requestAnimationFrame(frame);
    });
    resize();
    raf = requestAnimationFrame(frame);
  }

  document.addEventListener('DOMContentLoaded', () => {
    initCommands();
    initDesktopCanvas();
  });
})();
