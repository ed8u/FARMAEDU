/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pe.edu.utp.SistemaFarmaciaWeb.controlador;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pe.edu.utp.SistemaFarmaciaWeb.dao.ClienteDAO;
import pe.edu.utp.SistemaFarmaciaWeb.modelo.Cliente;

@WebServlet(name = "ClienteServlet", urlPatterns = {"/ClienteServlet"})
public class ClienteServlet extends HttpServlet {

    private final ClienteDAO dao = new ClienteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if (accion == null || accion.equalsIgnoreCase("listar")) {
            List<Cliente> lista = dao.listarActivos();
            request.setAttribute("listaClientes", lista);
            request.getRequestDispatcher("/WEB-INF/views/clientes.jsp").forward(request, response);

        } else if (accion.equalsIgnoreCase("eliminar")) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.eliminarLogico(id);
            } catch (NumberFormatException e) {
                System.err.println("Error ID Cliente inválido: " + e.getMessage());
            }
            response.sendRedirect("ClienteServlet?accion=listar");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accionForm");

        Cliente c = new Cliente();
        c.setTipoDocumento(request.getParameter("txtTipoDoc"));
        c.setDniRuc(request.getParameter("txtDniRuc"));
        c.setNombresRsocial(request.getParameter("txtNombres"));
        c.setEmail(request.getParameter("txtEmail"));
        c.setTelefono(request.getParameter("txtTelefono"));
        c.setDireccion(request.getParameter("txtDireccion"));

        if ("Guardar".equalsIgnoreCase(accion)) {
            dao.registrar(c);
        } else if ("Actualizar".equalsIgnoreCase(accion)) {
            c.setIdCliente(Integer.parseInt(request.getParameter("txtId")));
            dao.actualizar(c);
        }

        response.sendRedirect("ClienteServlet?accion=listar");
    }
}
