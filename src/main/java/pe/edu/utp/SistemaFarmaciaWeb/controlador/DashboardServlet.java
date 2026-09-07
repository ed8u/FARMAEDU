/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pe.edu.utp.SistemaFarmaciaWeb.controlador;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pe.edu.utp.SistemaFarmaciaWeb.dao.DashboardDAO;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/DashboardServlet"})
public class DashboardServlet extends HttpServlet {

    private final DashboardDAO dao = new DashboardDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Indicadores reales basados en los módulos implementados
        int totalClientes = dao.getTotalClientes();
        int totalMedicamentos = dao.getTotalMedicamentos();
        int lotesPorVencer = dao.getLotesPorVencer();
        int bajoStock = dao.getMedicamentosBajoStock();

        request.setAttribute("kpiClientes", totalClientes);
        request.setAttribute("kpiMedicamentos", totalMedicamentos);
        request.setAttribute("kpiLotesPorVencer", lotesPorVencer);
        request.setAttribute("kpiBajoStock", bajoStock);

        request.getRequestDispatcher("/WEB-INF/views/dashboard_admin.jsp").forward(request, response);
    }
}