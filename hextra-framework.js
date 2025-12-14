/* ===================================================================
   HEXTRA FRAMEWORK JS
   Handles interactions for the Hextra documentation theme
   =================================================================== */

document.addEventListener('DOMContentLoaded', () => {
    initSidebar();
    initTOC();
    initTabs();
    initSearch();
    initTheme();
});

/* ===================================================================
   SIDEBAR NAVIGATION
   =================================================================== */
function initSidebar() {
    // Collapsible Sections
    const toggles = document.querySelectorAll('.nav-section-toggle');
    
    toggles.forEach(toggle => {
        toggle.addEventListener('click', (e) => {
            e.preventDefault();
            const section = toggle.closest('.nav-section');
            section.classList.toggle('open');
            
            // Rotate icon
            const icon = toggle.querySelector('.toggle-icon');
            if (icon) {
                icon.style.transform = section.classList.contains('open') 
                    ? 'rotate(90deg)' 
                    : 'rotate(0deg)';
            }
        });
    });
}

/* ===================================================================
   TABLE OF CONTENTS SCROLL SPY
   =================================================================== */
function initTOC() {
    const observerOptions = {
        root: null,
        rootMargin: '-100px 0px -66%',
        threshold: 0
    };

    const headings = document.querySelectorAll('.hextra-content h2, .hextra-content h3');
    const tocLinks = document.querySelectorAll('.toc-link');

    if (headings.length === 0 || tocLinks.length === 0) return;

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const id = entry.target.getAttribute('id');
                
                // Remove active class from all links
                tocLinks.forEach(link => link.classList.remove('active'));
                
                // Add active class to corresponding link
                const activeLink = document.querySelector(`.toc-link[href="#${id}"]`);
                if (activeLink) {
                    activeLink.classList.add('active');
                    
                    // Scroll TOC to active link
                    activeLink.scrollIntoView({
                        behavior: 'smooth',
                        block: 'center'
                    });
                }
            }
        });
    }, observerOptions);

    headings.forEach(heading => observer.observe(heading));
}

/* ===================================================================
   TABS COMPONENT
   =================================================================== */
function initTabs() {
    const tabContainers = document.querySelectorAll('.tabs-container');
    
    tabContainers.forEach(container => {
        const buttons = container.querySelectorAll('.tab-button');
        const contents = container.querySelectorAll('.tab-content');
        
        buttons.forEach((button, index) => {
            button.addEventListener('click', () => {
                // Deactivate all
                buttons.forEach(b => b.classList.remove('active'));
                contents.forEach(c => c.classList.remove('active'));
                
                // Activate clicked
                button.classList.add('active');
                contents[index].classList.add('active');
            });
        });
    });
}

/* ===================================================================
   SEARCH FUNCTIONALITY
   =================================================================== */
function initSearch() {
    const searchInput = document.getElementById('sidebarSearch');
    if (!searchInput) return;

    searchInput.addEventListener('input', (e) => {
        const term = e.target.value.toLowerCase();
        const navItems = document.querySelectorAll('.sidebar-nav-link');
        
        navItems.forEach(item => {
            const text = item.textContent.toLowerCase();
            const match = text.includes(term);
            
            item.style.display = match ? 'flex' : 'none';
            
            if (term && match) {
                item.style.color = 'var(--primary-500)';
            } else {
                item.style.color = '';
            }
        });
    });

    // Keyboard shortcut (Ctrl+K)
    document.addEventListener('keydown', (e) => {
        if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
            e.preventDefault();
            searchInput.focus();
        }
    });
}

/* ===================================================================
   THEME TOGGLE
   =================================================================== */
function initTheme() {
    // Force dark mode for now as per user preference
    document.documentElement.classList.add('dark');
}
