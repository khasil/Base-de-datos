package modelo;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Modelo de Receta
 * Representa una receta de postre completa
 */
public class Receta {
    private int idReceta;
    private String titulo;
    private String descripcion;
    private Timestamp fechaCreacion;
    private int tiempoPreparacion;
    private String dificultad;
    private int idUsuario;
    private int idCategoria;
    private String nombreUsuario;
    private String nombreCategoria;
    private List<RecetaIngrediente> ingredientes;

    // Constructor vacío
    public Receta() {
        this.ingredientes = new ArrayList<>();
    }

    // Constructor con parámetros
    public Receta(int idReceta, String titulo, String descripcion, int tiempoPreparacion, 
                  String dificultad, int idUsuario, int idCategoria) {
        this();
        this.idReceta = idReceta;
        this.titulo = titulo;
        this.descripcion = descripcion;
        this.tiempoPreparacion = tiempoPreparacion;
        this.dificultad = dificultad;
        this.idUsuario = idUsuario;
        this.idCategoria = idCategoria;
    }

    // Getters y Setters
    public int getIdReceta() {
        return idReceta;
    }

    public void setIdReceta(int idReceta) {
        this.idReceta = idReceta;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public Timestamp getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(Timestamp fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public int getTiempoPreparacion() {
        return tiempoPreparacion;
    }

    public void setTiempoPreparacion(int tiempoPreparacion) {
        this.tiempoPreparacion = tiempoPreparacion;
    }

    public String getDificultad() {
        return dificultad;
    }

    public void setDificultad(String dificultad) {
        this.dificultad = dificultad;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public int getIdCategoria() {
        return idCategoria;
    }

    public void setIdCategoria(int idCategoria) {
        this.idCategoria = idCategoria;
    }

    public String getNombreUsuario() {
        return nombreUsuario;
    }

    public void setNombreUsuario(String nombreUsuario) {
        this.nombreUsuario = nombreUsuario;
    }

    public String getNombreCategoria() {
        return nombreCategoria;
    }

    public void setNombreCategoria(String nombreCategoria) {
        this.nombreCategoria = nombreCategoria;
    }

    public List<RecetaIngrediente> getIngredientes() {
        return ingredientes;
    }

    public void setIngredientes(List<RecetaIngrediente> ingredientes) {
        this.ingredientes = ingredientes;
    }

    public void agregarIngrediente(RecetaIngrediente ri) {
        this.ingredientes.add(ri);
    }

    @Override
    public String toString() {
        return "Receta{" +
                "idReceta=" + idReceta +
                ", titulo='" + titulo + '\'' +
                ", dificultad='" + dificultad + '\'' +
                ", tiempoPreparacion=" + tiempoPreparacion +
                ", categoria='" + nombreCategoria + '\'' +
                '}';
    }
}