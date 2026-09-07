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
import javax.servlet.http.HttpSession;
import pe.edu.utp.SistemaFarmaciaWeb.dao.UsuarioDAO;
import pe.edu.utp.SistemaFarmaciaWeb.modelo.Usuario;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    private final UsuarioDAO dao = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if ("CerrarSesion".equalsIgnoreCase(accion)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect("index.jsp");
        } else {
            response.sendRedirect("index.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");

        if ("Ingresar".equalsIgnoreCase(accion)) {
            String user = request.getParameter("txtUser");
            String pass = request.getParameter("txtPass");

            Usuario usr = dao.validar(user, pass);

            if (usr != null) {
                HttpSession session = request.getSession();
                session.setAttribute("usuarioLogueado", usr);

                if ("ADMINISTRADOR".equalsIgnoreCase(usr.getRol()) || "ADMIN".equalsIgnoreCase(usr.getRol())) {
                    response.sendRedirect("DashboardServlet");
                } else {
                    response.sendRedirect("MedicamentoServlet?accion=listar");
                }
            } else {
                request.setAttribute("error", "Credenciales incorrectas o usuario inactivo.");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }
        }
    }
}