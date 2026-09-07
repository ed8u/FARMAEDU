/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pe.edu.utp.SistemaFarmaciaWeb.controlador;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pe.edu.utp.SistemaFarmaciaWeb.dao.LoteMedicamentoDAO;
import pe.edu.utp.SistemaFarmaciaWeb.dao.MedicamentoDAO;
import pe.edu.utp.SistemaFarmaciaWeb.modelo.LoteMedicamento;

@WebServlet(name = "InventarioServlet", urlPatterns = {"/InventarioServlet"})
public class InventarioServlet extends HttpServlet {

    private final LoteMedicamentoDAO loteDao = new LoteMedicamentoDAO();
    private final MedicamentoDAO medDao = new MedicamentoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        if (accion == null || accion.equalsIgnoreCase("listar")) {
            List<LoteMedicamento> lista = loteDao.listarTodosFEFO();
            request.setAttribute("listaLotes", lista);
            request.setAttribute("listaMedicamentos", medDao.listarTodos()); // Para el select al ingresar lote
            request.getRequestDispatcher("/WEB-INF/views/inventario.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accionForm");

        if ("RegistrarLote".equalsIgnoreCase(accion)) {
            LoteMedicamento lote = new LoteMedicamento();
            lote.setIdMedicamento(Integer.parseInt(request.getParameter("cboMedicamento")));
            lote.setNumeroLote(request.getParameter("txtNumeroLote"));
            lote.setFechaVencimiento(LocalDate.parse(request.getParameter("txtFechaVencimiento"))); // Formato YYYY-MM-DD
            lote.setStockActual(Integer.parseInt(request.getParameter("txtCantidad")));

            loteDao.registrar(lote);
        }

        response.sendRedirect("InventarioServlet?accion=listar");
    }
}
