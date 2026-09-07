/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pe.edu.utp.SistemaFarmaciaWeb.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import pe.edu.utp.SistemaFarmaciaWeb.config.ConexionDB;
import pe.edu.utp.SistemaFarmaciaWeb.modelo.*;

public class CatalogoDAO {

    public List<Categoria> listarCategorias() {
        List<Categoria> lista = new ArrayList<>();
        String sql = "SELECT id_categoria, nombre_categoria, estado FROM Categorias WHERE estado = 1 ORDER BY nombre_categoria";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(new Categoria(rs.getInt("id_categoria"), rs.getString("nombre_categoria"), rs.getBoolean("estado")));
            }
        } catch (Exception e) {
            System.err.println("Error al listar categorias: " + e.getMessage());
        }
        return lista;
    }

    public List<Laboratorio> listarLaboratorios() {
        List<Laboratorio> lista = new ArrayList<>();
        String sql = "SELECT id_laboratorio, nombre_laboratorio, estado FROM Laboratorios WHERE estado = 1 ORDER BY nombre_laboratorio";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(new Laboratorio(rs.getInt("id_laboratorio"), rs.getString("nombre_laboratorio"), rs.getBoolean("estado")));
            }
        } catch (Exception e) {
            System.err.println("Error al listar laboratorios: " + e.getMessage());
        }
        return lista;
    }

    public List<PrincipioActivo> listarPrincipios() {
        List<PrincipioActivo> lista = new ArrayList<>();
        String sql = "SELECT id_principio, nombre_principio, estado FROM PrincipiosActivos WHERE estado = 1 ORDER BY nombre_principio";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(new PrincipioActivo(rs.getInt("id_principio"), rs.getString("nombre_principio"), rs.getBoolean("estado")));
            }
        } catch (Exception e) {
            System.err.println("Error al listar principios: " + e.getMessage());
        }
        return lista;
    }

    public List<FormaFarmaceutica> listarFormas() {
        List<FormaFarmaceutica> lista = new ArrayList<>();
        String sql = "SELECT id_forma, nombre_forma, estado FROM FormasFarmaceuticas WHERE estado = 1 ORDER BY nombre_forma";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(new FormaFarmaceutica(rs.getInt("id_forma"), rs.getString("nombre_forma"), rs.getBoolean("estado")));
            }
        } catch (Exception e) {
            System.err.println("Error al listar formas: " + e.getMessage());
        }
        return lista;
    }

    public List<Presentacion> listarPresentaciones() {
        List<Presentacion> lista = new ArrayList<>();
        String sql = "SELECT id_presentacion, nombre_presentacion, estado FROM Presentaciones WHERE estado = 1 ORDER BY nombre_presentacion";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(new Presentacion(rs.getInt("id_presentacion"), rs.getString("nombre_presentacion"), rs.getBoolean("estado")));
            }
        } catch (Exception e) {
            System.err.println("Error al listar presentaciones: " + e.getMessage());
        }
        return lista;
    }
}
