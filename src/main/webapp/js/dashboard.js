document.addEventListener("DOMContentLoaded", function() {
    const canvas = document.getElementById('areaChart');
    if(canvas) {
        const ctxArea = canvas.getContext('2d');
        
        let gradient = ctxArea.createLinearGradient(0, 0, 0, 250);
        gradient.addColorStop(0, 'rgba(16, 185, 129, 0.2)'); 
        gradient.addColorStop(1, 'rgba(16, 185, 129, 0)');   

        new Chart(ctxArea, {
            type: 'line',
            data: {
                labels: ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Hoy'],
                datasets: [{
                    label: 'Ventas (S/)',
                    data: [1200, 1900, 1500, 2100, 1800, 2500, 1485],
                    borderColor: '#10b981',
                    backgroundColor: gradient,
                    borderWidth: 2,
                    pointBackgroundColor: '#ffffff',
                    pointBorderColor: '#10b981',
                    pointRadius: 4,
                    fill: true,
                    tension: 0.4 
                }]
            },
            options: { 
                responsive: true, 
                maintainAspectRatio: false, 
                plugins: { legend: { display: false } },
                scales: {
                    x: { grid: { display: false } },
                    y: { border: { display: false }, grid: { color: '#f1f5f9' } }
                }
            }
        });
    }
});

