// Sidebar Toggle Functionality
window.SidebarManager = {
    init: function() {
        // Lade gespeicherten Status beim Start
        var collapsed = localStorage.getItem('sidebarCollapsed') === 'true';
        var page = document.querySelector('.page');
        if (page && collapsed) {
            page.classList.add('sidebar-collapsed');
            console.log('Sidebar: Initial state - collapsed');
        }
    },
    
    toggle: function() {
        var page = document.querySelector('.page');
        if (page) {
            page.classList.toggle('sidebar-collapsed');
            var isCollapsed = page.classList.contains('sidebar-collapsed');
            localStorage.setItem('sidebarCollapsed', isCollapsed.toString());
            console.log('Sidebar toggled:', isCollapsed ? 'collapsed' : 'expanded');
            return isCollapsed;
        }
        console.error('Sidebar: .page element not found');
        return false;
    },
    
    isCollapsed: function() {
        var page = document.querySelector('.page');
        return page ? page.classList.contains('sidebar-collapsed') : false;
    }
};

// Auto-init wenn DOM bereit
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function() {
        SidebarManager.init();
    });
} else {
    SidebarManager.init();
}
