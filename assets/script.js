document.addEventListener('DOMContentLoaded', function () {
    const rows = document.querySelectorAll('tbody tr:not(.expandable)');
    rows.forEach(row => {
        row.addEventListener('click', function () {
            const nextRow = row.nextElementSibling;
            if (nextRow && nextRow.classList.contains('expandable')) {
                nextRow.style.display = nextRow.style.display === 'table-row' ? 'none' : 'table-row';
            }
        });
    });
});

function toggleTables() {
    const mostViewsContainer = document.getElementById('mostViewsContainer');
    const uniqueViewsContainer = document.getElementById('uniqueViewsContainer');
    const button = document.getElementById("toggleButton");
    const tableInfo = document.getElementById("tableInfo");

    if (mostViewsContainer.style.display === 'none') {
        mostViewsContainer.style.display = 'block';
        uniqueViewsContainer.style.display = 'none';
        button.innerHTML = "Sort by Unique Visitors";
        tableInfo.innerHTML = "Sorted by Most Viewed Pages";
    } else {
        mostViewsContainer.style.display = 'none';
        uniqueViewsContainer.style.display = 'block';
        button.innerHTML = "Sort by Hits";
        tableInfo.innerHTML = "Sorted by Unique Visitors";
    }
}
