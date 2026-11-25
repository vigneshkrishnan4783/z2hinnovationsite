// Z2H Innovations & R&D Lab — Interactive Behaviors, Bubbles & Side Wave Nav

document.addEventListener('DOMContentLoaded', () => {
  // 1. Mobile Navigation Drawer
  const navToggle = document.querySelector('[data-nav-toggle]');
  const mobileDrawer = document.querySelector('[data-mobile-drawer]');

  if (navToggle && mobileDrawer) {
    navToggle.addEventListener('click', () => {
      const isOpen = mobileDrawer.classList.toggle('is-open');
      navToggle.setAttribute('aria-expanded', String(isOpen));
      document.body.style.overflow = isOpen ? 'hidden' : '';
    });

    mobileDrawer.querySelectorAll('a, button').forEach((item) => {
      item.addEventListener('click', () => {
        mobileDrawer.classList.remove('is-open');
        navToggle.setAttribute('aria-expanded', 'false');
        document.body.style.overflow = '';
      });
    });
  }

  // 2. Scroll Reveal Animation
  const revealEls = document.querySelectorAll('[data-reveal]');
  if ('IntersectionObserver' in window && revealEls.length) {
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add('is-visible');
            observer.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.12, rootMargin: '0px 0px -30px 0px' }
    );
    revealEls.forEach((el) => observer.observe(el));
  } else {
    revealEls.forEach((el) => el.classList.add('is-visible'));
  }

  // 3. Category Filtering (Services & Careers)
  document.querySelectorAll('[data-filter-group]').forEach((group) => {
    const buttons = group.querySelectorAll('[data-filter]');
    const targetSelector = group.getAttribute('data-filter-group');
    const items = document.querySelectorAll(targetSelector);

    buttons.forEach((btn) => {
      btn.addEventListener('click', () => {
        const filter = btn.getAttribute('data-filter');
        buttons.forEach((b) => b.classList.remove('is-active'));
        btn.classList.add('is-active');

        items.forEach((item) => {
          const categories = (item.getAttribute('data-category') || '').split(/\s+/);
          const match = filter === 'all' || categories.includes(filter);
          item.classList.toggle('is-hidden', !match);
        });
      });
    });
  });

  // 4. Modals (Project Proposal & Career Application)
  const openButtons = document.querySelectorAll('[data-modal-open]');
  const modals = document.querySelectorAll('[data-modal]');

  const closeAllModals = () => {
    modals.forEach((m) => m.classList.remove('is-open'));
    document.body.style.overflow = '';
  };

  openButtons.forEach((btn) => {
    btn.addEventListener('click', () => {
      const modalId = btn.getAttribute('data-modal-open');
      const modal = document.getElementById(modalId);
      if (!modal) return;

      const roleValue = btn.getAttribute('data-role');
      const roleInput = modal.querySelector('[data-role-input]');
      if (roleValue && roleInput) {
        roleInput.value = roleValue;
      }

      const status = modal.querySelector('.form-status');
      if (status) status.classList.remove('is-visible');

      modal.classList.add('is-open');
      document.body.style.overflow = 'hidden';
    });
  });

  modals.forEach((modal) => {
    modal.addEventListener('click', (e) => {
      if (e.target === modal || e.target.closest('[data-modal-close]')) {
        closeAllModals();
      }
    });

    const form = modal.querySelector('form');
    if (form) {
      form.addEventListener('submit', (e) => {
        e.preventDefault();
        const status = modal.querySelector('.form-status');
        if (status) {
          status.classList.add('is-visible');
        }
        form.reset();
      });
    }
  });

  // 5. Header & Background Cursor Bubbles
  const bgLayer = document.createElement('div');
  bgLayer.className = 'bg-bubble-layer';
  document.body.appendChild(bgLayer);

  const headerLayer = document.createElement('div');
  headerLayer.className = 'header-bubble-layer';
  document.body.appendChild(headerLayer);

  let lastBubbleTime = 0;
  const spawnBubble = (layer, x, y, size) => {
    const b = document.createElement('span');
    b.className = 'cursor-bubble';
    b.style.left = `${x}px`;
    b.style.top = `${y}px`;
    b.style.width = `${size}px`;
    b.style.height = `${size}px`;
    b.style.setProperty('--dx', `${(Math.random() - 0.5) * 44}px`);
    b.style.setProperty('--dy', `${-20 - Math.random() * 45}px`);
    layer.appendChild(b);
    setTimeout(() => b.remove(), 1400);
  };

  const headerEl = document.querySelector('.site-header');
  if (headerEl) {
    headerEl.addEventListener('mousemove', (e) => {
      const now = Date.now();
      if (now - lastBubbleTime < 45) return;
      lastBubbleTime = now;
      spawnBubble(headerLayer, e.clientX, e.clientY, 5 + Math.random() * 7);
    });
  }

  document.addEventListener('mousemove', (e) => {
    const now = Date.now();
    if (now - lastBubbleTime < 75) return;
    lastBubbleTime = now;
    spawnBubble(bgLayer, e.clientX, e.clientY, 6 + Math.random() * 10);
  });

  // 6. Borderless Left & Right Edge Hover Navigation
  const currentPath = window.location.pathname.split('/').pop() || 'index.html';
  const navMarkup = [
    { href: 'index.html', label: 'Home' },
    { href: 'services.html', label: 'Services' },
    { href: 'careers.html', label: 'Careers' },
  ]
    .map(
      (item) =>
        `<a href="${item.href}" class="${currentPath === item.href ? 'is-active' : ''}">${item.label}</a>`
    )
    .join('');

  const leftNav = document.createElement('nav');
  leftNav.className = 'side-wave-nav side-wave-nav--left';
  leftNav.setAttribute('aria-label', 'Left Side Navigation');
  leftNav.innerHTML = navMarkup;

  const rightNav = document.createElement('nav');
  rightNav.className = 'side-wave-nav side-wave-nav--right';
  rightNav.setAttribute('aria-label', 'Right Side Navigation');
  rightNav.innerHTML = navMarkup;

  document.body.appendChild(leftNav);
  document.body.appendChild(rightNav);

  let hideNavTimer = null;
  document.addEventListener('mousemove', (e) => {
    const nearLeft = e.clientX <= 36 || leftNav.matches(':hover');
    const nearRight = e.clientX >= window.innerWidth - 36 || rightNav.matches(':hover');

    if (nearLeft) {
      clearTimeout(hideNavTimer);
      leftNav.classList.add('is-open');
      rightNav.classList.remove('is-open');
    } else if (nearRight) {
      clearTimeout(hideNavTimer);
      rightNav.classList.add('is-open');
      leftNav.classList.remove('is-open');
    } else {
      clearTimeout(hideNavTimer);
      hideNavTimer = setTimeout(() => {
        if (!leftNav.matches(':hover')) leftNav.classList.remove('is-open');
        if (!rightNav.matches(':hover')) rightNav.classList.remove('is-open');
      }, 420);
    }
  });

  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
      closeAllModals();
    }
  });
});
