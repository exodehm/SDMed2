--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.17
-- Dumped by pg_dump version 9.5.17

-- Started on 2019-05-13 19:57:54 CEST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 1 (class 3079 OID 12435)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2482 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 750 (class 1247 OID 119400)
-- Name: tp_certificacion; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tp_certificacion AS (
	fecha date,
	actual boolean
);


ALTER TYPE public.tp_certificacion OWNER TO postgres;

--
-- TOC entry 697 (class 1247 OID 68362)
-- Name: tp_color; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tp_color AS ENUM (
    'NORMAL',
    'BLOQUEADO',
    'DESCOMPUESTO'
);


ALTER TYPE public.tp_color OWNER TO postgres;

--
-- TOC entry 766 (class 1247 OID 68336)
-- Name: tp_concepto; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tp_concepto AS (
	codigo character varying(20),
	resumen character varying(50),
	descripcion text,
	descripcionhtml text,
	preciomed numeric(15,3),
	preciobloq numeric(15,3),
	naturaleza integer,
	fecha date,
	ud character varying(5),
	preciocert numeric(15,3)
);


ALTER TYPE public.tp_concepto OWNER TO postgres;

--
-- TOC entry 726 (class 1247 OID 116483)
-- Name: tp_copiarconcepto; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tp_copiarconcepto AS (
	idcopiar integer,
	paso integer,
	c public.tp_concepto
);


ALTER TYPE public.tp_copiarconcepto OWNER TO postgres;

--
-- TOC entry 769 (class 1247 OID 68348)
-- Name: tp_relacion; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tp_relacion AS (
	id integer,
	codpadre character varying,
	codhijo character varying,
	canpres numeric(7,3),
	cancert numeric(7,3),
	posicion smallint
);


ALTER TYPE public.tp_relacion OWNER TO postgres;

--
-- TOC entry 729 (class 1247 OID 116486)
-- Name: tp_copiarrelacion; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tp_copiarrelacion AS (
	idcopiar integer,
	grupo integer,
	r public.tp_relacion
);


ALTER TYPE public.tp_copiarrelacion OWNER TO postgres;

--
-- TOC entry 756 (class 1247 OID 118267)
-- Name: tp_guardarconcepto; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tp_guardarconcepto AS (
	idguardar integer,
	paso integer,
	c public.tp_concepto
);


ALTER TYPE public.tp_guardarconcepto OWNER TO postgres;

--
-- TOC entry 747 (class 1247 OID 115238)
-- Name: tp_medicion; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tp_medicion AS (
	id integer,
	num_certif integer,
	tipo integer,
	comentario character varying(120),
	ud numeric,
	longitud numeric(7,3),
	anchura numeric(7,3),
	altura numeric(7,3),
	formula character varying(80),
	codpadre character varying,
	codhijo character varying,
	posicion integer
);


ALTER TYPE public.tp_medicion OWNER TO postgres;

--
-- TOC entry 791 (class 1247 OID 117883)
-- Name: tp_guardarmedicion; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tp_guardarmedicion AS (
	idguardar integer,
	paso integer,
	m public.tp_medicion
);


ALTER TYPE public.tp_guardarmedicion OWNER TO postgres;

--
-- TOC entry 753 (class 1247 OID 118264)
-- Name: tp_guardarrelacion; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tp_guardarrelacion AS (
	idguardar integer,
	paso integer,
	r public.tp_relacion
);


ALTER TYPE public.tp_guardarrelacion OWNER TO postgres;

--
-- TOC entry 784 (class 1247 OID 68380)
-- Name: tp_lineamedicion; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tp_lineamedicion AS (
	fase integer,
	comentario character varying,
	ud numeric,
	longitud numeric,
	anchura numeric,
	altura numeric,
	formula character varying,
	parcial numeric,
	subtotal numeric,
	id integer,
	pos integer
);


ALTER TYPE public.tp_lineamedicion OWNER TO postgres;

--
-- TOC entry 781 (class 1247 OID 68377)
-- Name: tp_partida; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tp_partida AS (
	codigopadre character varying,
	codigohijo character varying,
	pos smallint,
	ud character varying,
	resumen character varying(50),
	descripcion text,
	precio numeric(15,3),
	cantidad numeric(7,3),
	nat integer,
	fec character varying
);


ALTER TYPE public.tp_partida OWNER TO postgres;

--
-- TOC entry 324 (class 1255 OID 115741)
-- Name: actualizar_certificacion_actual(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.actualizar_certificacion_actual(_nombretabla character varying, _fecha character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
tabla_listado_certificaciones character varying := _nombretabla || '_ListadoCertificaciones';
BEGIN
EXECUTE FORMAT ('UPDATE %I SET actual = ''false''',tabla_listado_certificaciones);
EXECUTE FORMAT ('UPDATE %I SET actual = ''true'' WHERE fecha::character varying = $1',tabla_listado_certificaciones) USING _fecha;
END;
$_$;


ALTER FUNCTION public.actualizar_certificacion_actual(_nombretabla character varying, _fecha character varying) OWNER TO postgres;

--
-- TOC entry 283 (class 1255 OID 119247)
-- Name: actualizar_desde_nodo(character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.actualizar_desde_nodo(_nombretabla character varying, _codigonodo character varying, _num_cert integer DEFAULT 0) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    nuevo_precio numeric;
    r record;
    existe boolean;
    bloqueado numeric(7,3);
    tablaconceptos character varying := _nombretabla || '_Conceptos';
    tablarelacion character varying := _nombretabla || '_Relacion';
    str_null_case character varying;
    columnacantidad character varying;
    columnaprecio character varying;
BEGIN
--PRIMER PASO, DEFINIR SI MODIFICO LAS COLUMNAS preciomed/canpres o preciocert/cancert
IF _num_cert = 0 THEN
    columnaprecio := 'preciomed';
    columnacantidad := 'canpres';
ELSE
    columnaprecio := 'preciocert';
    columnacantidad := 'cancert';
END IF;
--definimos la cadena del codigo padre, por si es nula
IF (_codigonodo = '') IS NOT FALSE THEN
	str_null_case := ' IS NULL';
ELSE
	str_null_case := ' = '||quote_literal(_codigonodo);
END IF;
--primera comprobacion, que sea un precio bloqueado
EXECUTE FORMAT ('SELECT preciobloq FROM %I WHERE codigo %s',tablaconceptos,str_null_case) INTO bloqueado;
IF (bloqueado IS NOT NULL) THEN 
    nuevo_precio = bloqueado;
ELSE
    EXECUTE FORMAT ('SELECT EXISTS (SELECT codpadre FROM %I WHERE codpadre %s)',tablarelacion,str_null_case) INTO existe;
    IF existe = FALSE
        THEN
            EXECUTE FORMAT ('SELECT %s FROM %I WHERE codigo %s',columnaprecio,tablaconceptos,str_null_case) INTO nuevo_precio;		
        ELSE
            EXECUTE FORMAT ('SELECT SUM(importe) FROM (SELECT C.codigo, C.resumen, C.%s, R.%s, C.%s * R.%s AS "importe"
		FROM %I AS C,%I AS R 
		WHERE codpadre %s AND R.codhijo = C.codigo) AS subtotal', columnaprecio, columnacantidad, columnaprecio, columnacantidad,
		tablaconceptos,tablarelacion, str_null_case) INTO nuevo_precio;
    END IF;
END IF;
IF nuevo_precio IS NULL THEN nuevo_precio = 0; END IF;
EXECUTE FORMAT ('UPDATE %I SET %s = %L WHERE codigo %s', tablaconceptos, columnaprecio, nuevo_precio, str_null_case);
--RAISE NOTICE 'El valor del nodo es: %', nuevo_precio;
EXECUTE FORMAT ('SELECT EXISTS (SELECT codhijo FROM %I WHERE codhijo %s)', tablarelacion, str_null_case) INTO existe;
IF existe = TRUE THEN
	FOR r IN EXECUTE FORMAT ('SELECT * FROM %I WHERE codhijo %s', tablarelacion, str_null_case)
	LOOP
		--RAISE NOTICE 'Hay que seguir para arriba con: %,%',r.codpadre,r.codhijo;
		EXECUTE FORMAT ('SELECT actualizar_desde_nodo(%s,%s,%s)', quote_literal(_nombretabla), 
		CASE WHEN r.codpadre IS NULL THEN 'NULL' ELSE quote_literal(r.codpadre) END,
		_num_cert);
	END LOOP;
END IF;
END;
$$;


ALTER FUNCTION public.actualizar_desde_nodo(_nombretabla character varying, _codigonodo character varying, _num_cert integer) OWNER TO postgres;

--
-- TOC entry 260 (class 1255 OID 18492)
-- Name: actualizar_parcial(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.actualizar_parcial() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

DECLARE
suma_inicial numeric;
suma_final numeric;
BEGIN

suma_inicial = (SELECT SUM(parcial) FROM mediciones WHERE id_rel_padre = OLD.id_rel_padre AND id_rel_hijo = OLD.id_rel_hijo);
RAISE NOTICE 'La cantidad inicial es: %',suma_inicial;

	NEW.parcial := NEW.ud*
CASE WHEN NEW.longitud IS NULL THEN 1 ELSE NEW.longitud END*
CASE WHEN NEW.anchura IS NULL THEN 1 ELSE NEW.anchura END*
CASE WHEN NEW.altura IS NULL THEN 1 ELSE NEW.altura END;
--RAISE NOTICE 'Valores que intervienen: %*%*%*%=%',NEW.id,NEW.longitud,NEW.anchura,NEW.altura,NEW.parcial;
--suma = (SELECT SUM(NEW.parcial) FROM mediciones);
RAISE NOTICE 'Actualizar la relacion %,%',NEW.id_rel_padre,NEW.id_rel_hijo;
suma_final= suma_inicial-OLD.parcial+NEW.parcial;
RAISE NOTICE 'La cantidad final es: %',suma_final;
UPDATE relacion SET cantidad = suma_final WHERE id_padre = NEW.id_rel_padre AND id_hijo = NEW.id_rel_hijo;
PERFORM actualizar_desde_nodo(NEW.id_rel_padre);
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.actualizar_parcial() OWNER TO postgres;

--
-- TOC entry 278 (class 1255 OID 18986)
-- Name: actualizar_partida(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.actualizar_partida() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

DECLARE
BEGIN
RAISE NOTICE 'Actualizar desde nodo: %',OLD.id;
PERFORM (actualizar_desde_nodo(OLD.id));
RETURN NEW;
END;
$$;


ALTER FUNCTION public.actualizar_partida() OWNER TO postgres;

--
-- TOC entry 323 (class 1255 OID 115584)
-- Name: anadir_certificacion(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.anadir_certificacion(_nombretabla character varying, _fecha character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
tabla_listado_certificaciones character varying := _nombretabla || '_ListadoCertificaciones';
fecha date := procesar_cadena_fecha(_fecha);
resultado boolean := false;
actual boolean := true;
existe boolean;
ultima_fecha date;

BEGIN
--PRIMERO CREO LA TABLA DE CERTIFICACIONES Y LA SECUENCIA, SI NO ESTA YA CREADA
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %L)', tabla_listado_certificaciones) INTO existe;
IF existe IS FALSE THEN
	EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I of tp_certificacion (PRIMARY KEY (fecha))',tabla_listado_certificaciones);	
END IF;
--AHORA INSERTO LA NUEVA CERTIFICACION. LA FUNCION COMPRUEBA QUE LA FECHA SEA MAYOR A LA ULTIMA INGRESADA.SI NO LO ES, NO HACE NADA Y RETORNA FALSE
EXECUTE FORMAT ('SELECT MAX(fecha) FROM %I',tabla_listado_certificaciones) INTO ultima_fecha;
IF ultima_fecha IS NULL OR fecha > ultima_fecha THEN
	EXECUTE FORMAT ('INSERT INTO %I (fecha, actual) VALUES ($1,$2)',tabla_listado_certificaciones) USING fecha, actual;
	--pongo el resto de certificaciones a false el dato de actual
	EXECUTE FORMAT ('UPDATE %I SET actual = ''false'' WHERE fecha <>$1',tabla_listado_certificaciones) USING fecha;
	resultado = true;
END IF;
return resultado;
END;
$_$;


ALTER FUNCTION public.anadir_certificacion(_nombretabla character varying, _fecha character varying) OWNER TO postgres;

--
-- TOC entry 280 (class 1255 OID 20163)
-- Name: anadir_obra_a_listado(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.anadir_obra_a_listado(codigo character varying, resumen character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
noexiste boolean;
BEGIN
EXECUTE format (
		'CREATE TABLE IF NOT EXISTS listaobras
		(id serial NOT NULL,
		codigo character varying(20),
		resumen character varying(50),
		CONSTRAINT "listado_pkey" PRIMARY KEY (id));'
		);
EXECUTE FORMAT ('SELECT NOT EXISTS (SELECT codigo FROM listaobras WHERE codigo = %s)', quote_literal(codigo)) INTO noexiste;
IF noexiste = TRUE THEN

EXECUTE format ('INSERT INTO %I(codigo,resumen) VALUES
		(%s,%s)',
		'listaobras',quote_literal(codigo),quote_literal(resumen));

RETURN 0;
END IF;
RETURN -1;
EXCEPTION 
    WHEN others THEN
        RAISE INFO 'Error Name:%',SQLERRM;
        RAISE INFO 'Error State:%', SQLSTATE;
        RETURN -1;
END;
$$;


ALTER FUNCTION public.anadir_obra_a_listado(codigo character varying, resumen character varying) OWNER TO postgres;

--
-- TOC entry 326 (class 1255 OID 42757)
-- Name: bloquear_precio(character varying, character varying, numeric, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.bloquear_precio(nombretabla character varying, codigo character varying, precio numeric, bloquear boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN
IF bloquear = TRUE THEN	
    EXECUTE FORMAT ('UPDATE %I SET preciobloq = %s WHERE codigo=%s',nombretabla||'_Conceptos',quote_literal(precio),quote_literal(codigo));
ELSE
    EXECUTE FORMAT ('UPDATE %I SET preciobloq = NULL WHERE codigo=%s',nombretabla||'_Conceptos',quote_literal(codigo));
END IF;
END;
$$;


ALTER FUNCTION public.bloquear_precio(nombretabla character varying, codigo character varying, precio numeric, bloquear boolean) OWNER TO postgres;

--
-- TOC entry 285 (class 1255 OID 119407)
-- Name: borrar_certificacion(character varying, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.borrar_certificacion(_nombretabla character varying, _fecha date) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
tabla_mediciones character varying := _nombretabla || '_Mediciones';
tabla_listado_certificaciones character varying := _nombretabla || '_ListadoCertificaciones';
num_cert integer;
BEGIN
--obtengo el num de certificacion con la fecha dada
	EXECUTE FORMAT ('SELECT num_cert FROM (SELECT *, count(*) OVER (ORDER BY fecha ) AS num_cert 
		FROM %I) AS tabla WHERE fecha = $1',tabla_listado_certificaciones) USING _fecha INTO num_cert;
--borro de la tabla de mediciones las filas con ese numero de certificacion
	EXECUTE FORMAT ('DELETE FROM %I WHERE num_certif = $1',tabla_mediciones) USING num_cert;
--modifico los numeros de certificacion de las que tengan un numero superior
	EXECUTE FORMAT ('UPDATE %I SET num_certif = num_certif-1 WHERE num_certif > $1',tabla_mediciones) USING num_cert;
--por ultimo borro la certificacion de la tabla de listado de certificaciones
	EXECUTE FORMAT ('DELETE FROM %I WHERE fecha = $1',tabla_listado_certificaciones) USING _fecha;
RETURN num_cert;	
END;
$_$;


ALTER FUNCTION public.borrar_certificacion(_nombretabla character varying, _fecha date) OWNER TO postgres;

--
-- TOC entry 332 (class 1255 OID 118066)
-- Name: borrar_hijos(character varying, character varying, character varying, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.borrar_hijos(_nombretabla character varying, _codigopadre character varying, _codigohijos character varying DEFAULT NULL::character varying, _guardar boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $_$ 
DECLARE
--la funcion borrar los hijos de un nodo y lo que hay debajo de ellos y los guarda en una tabla para su posterior restauracion
--si se deshace la accion. Tambien se definira el tipo de accion que -pegado o borrado- para tenerlo en cuenta a la hora
-- de sacarlo de la tabla
num_paso integer;
tablaconceptos character varying := _nombretabla || '_Conceptos';
tablarelacion character varying := _nombretabla || '_Relacion';

tablaguardarconceptos character varying := _nombretabla || '_GuardarConceptos';
tablaguardarrelacion character varying := _nombretabla || '_GuardarRelaciones';
tablaguardarmedicion character varying := _nombretabla || '_GuardarMediciones';
tablaguardarcertificacion character varying := _nombretabla || '_GuardarCertificaciones';
arraycodigoshijos character varying[];

r tp_relacion%ROWTYPE;
rg tp_guardarrelacion%ROWTYPE;
c tp_concepto%ROWTYPE;
cg tp_guardarconcepto%ROWTYPE;
existe boolean;
BEGIN
IF _codigohijos IS NULL THEN --SI NO HAY ARRAY DE CODIGOS HIJO BORRO TODOS LOS QUE PENDEN DEL PADRE
	EXECUTE FORMAT('SELECT array_agg(codhijo) from %I WHERE codpadre = $1', tablarelacion) INTO arraycodigoshijos USING _codigopadre;
ELSE --SI HAY CADENA DE ARRAY DE CODIGOS, LOS METO EN EL ARRAY DE LA FUNCION
	arraycodigoshijos = string_to_array(_codigohijos,',');
	raise notice 'el array a borrar es: %',arraycodigoshijos;
END IF;
--FINALMENTE EJECUTO LA FUNCION
PERFORM borrar_lineas_principal(_nombretabla,_codigopadre,arraycodigoshijos,_guardar);
--ACTUALIZO LOS NUMEROS DE PASO DE LAS TABLAS SI GUARDAR ES TRUE
IF _guardar IS TRUE THEN
	num_paso = (SELECT ultimo_paso(_nombretabla)) + 1;
	--para la tabla de guardar relacion no hago comprobacion previa porque siempre va a haber en el momento de borrar...se puede añadir esa comprobacion
	EXECUTE FORMAT ('UPDATE %I SET paso = %s WHERE paso IS NULL',tablaguardarrelacion,num_paso);
	--actualizar tabla guardar conceptos
	EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %L)', tablaguardarconceptos) INTO existe;
	IF existe IS TRUE THEN
		EXECUTE FORMAT ('UPDATE %I SET paso = %s WHERE paso IS NULL',tablaguardarconceptos,num_paso);
	END IF;
	--actualizar tabla guardar medicion
	EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %L)', tablaguardarmedicion) INTO existe;
	IF existe IS TRUE THEN
		EXECUTE FORMAT ('UPDATE %I SET paso = %s WHERE paso IS NULL',tablaguardarmedicion,num_paso);
	END IF;
	--actualizar tabla guardar certificacion
	EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %L)', tablaguardarcertificacion) INTO existe;
	IF existe IS TRUE THEN
		EXECUTE FORMAT ('UPDATE %I SET paso = %s WHERE paso IS NULL',tablaguardarcertificacion,num_paso);
	END IF;
END IF;
--Por ultimo actualizamos las cantidades
PERFORM actualizar_desde_nodo(_nombretabla,_codigopadre);
END;
$_$;


ALTER FUNCTION public.borrar_hijos(_nombretabla character varying, _codigopadre character varying, _codigohijos character varying, _guardar boolean) OWNER TO postgres;

--
-- TOC entry 299 (class 1255 OID 122506)
-- Name: borrar_lineas_medcert(character varying, integer[], integer, boolean, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.borrar_lineas_medcert(_nombretabla character varying, _ids integer[], _num_cert integer DEFAULT NULL::integer, _guardar boolean DEFAULT true, _solomedicion boolean DEFAULT false) RETURNS void
    LANGUAGE plpgsql
    AS $_$ 
DECLARE
    tamanno integer := array_length(_ids, 1);    
    tablamedcert character varying := _nombretabla || '_Mediciones';
    tablaguardarmedcert character varying := _nombretabla || '_GuardarMediciones';
    codigopadre character varying;
    codigohijo character varying;
    m tp_medicion%ROWTYPE;
    num_paso integer := NULL;
    existe boolean;
    pos integer := 0;
--SI LA FUNCION ES LLAMADA DESDE LA FUNCION borrar_lineas_principal, SERA ESTA LA QUE PONGA EL num_paso, PERO SI SE LLAMA
--DE FORMA DIRECTA SE PONDRA DESDE LA PROPIA FUNCION
BEGIN
raise notice 'array de hijos a borrar: % ',_ids;
--AHORA CREO LA TABLA DE GUARDAR
IF _guardar IS TRUE THEN
	EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF tp_guardarmedicion (PRIMARY KEY (idguardar))',tablaguardarmedcert);
END IF;
--SOLO EJECUTO SI HAY ARRAY DE LINEAS DE MEDICION
IF tamanno IS NOT NULL THEN
	EXECUTE FORMAT ('SELECT codpadre FROM %I WHERE id = %L',tablamedcert,_ids[1]) INTO codigopadre;
	EXECUTE FORMAT ('SELECT codhijo FROM %I WHERE id = %L',tablamedcert,_ids[1]) INTO codigohijo;
	
	FOR i IN 1..tamanno LOOP
		IF _guardar IS TRUE THEN  --solo guardare en la tabla de guardar medicion si guardar es true
			EXECUTE FORMAT ('SELECT * FROM %I WHERE %I.id = %L',tablamedcert,tablamedcert, _ids[i]) INTO m;
			PERFORM insertar_registro_guardarmedicion(tablaguardarmedcert,NULL,m);
		END IF;
		EXECUTE FORMAT ('DELETE FROM %I WHERE %I.id = %L',tablamedcert,tablamedcert,_ids[i]);
	END LOOP;
	--reorganizamos las posiciones (solo si borro en una tabla concreta)
	IF _num_cert IS NOT NULL THEN
		FOR m IN EXECUTE FORMAT('SELECT * FROM %I WHERE codpadre = $1 AND codhijo = $2 AND num_certif = $3 ORDER BY posicion',tablamedcert) USING codigopadre,codigohijo,_num_cert
		LOOP
			EXECUTE FORMAT ('UPDATE %I SET posicion = $1 WHERE id = $2', tablamedcert)
			USING pos, m.id;
			pos = pos +1;
		END LOOP;
	END IF;
	--ponemos el numero de paso solo si es borrado directo de medicion. Si las mediciones se borran porque se han borrado partidas esta parte no se ejecuta
	--y el numero de paso lo pone la funcion que borra la partida
	IF _solomedicion IS TRUE THEN
		num_paso = (SELECT ultimo_paso(_nombretabla));		
		EXECUTE FORMAT ('UPDATE %I SET paso = %s WHERE paso IS NULL',tablaguardarmedcert,num_paso+1);--aumento el num_paso una unidad
	END IF;
	--por ultimo recalculamos las cantidades
	PERFORM modificar_cantidad(_nombretabla,codigopadre,codigohijo,_num_cert);
END IF;    
   END;
$_$;


ALTER FUNCTION public.borrar_lineas_medcert(_nombretabla character varying, _ids integer[], _num_cert integer, _guardar boolean, _solomedicion boolean) OWNER TO postgres;

--
-- TOC entry 302 (class 1255 OID 139347)
-- Name: borrar_lineas_medcert(character varying, character varying, character varying, integer, integer[], boolean, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.borrar_lineas_medcert(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _num_cert integer, _posiciones integer[] DEFAULT NULL::integer[], _guardar boolean DEFAULT true, _solomedicion boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $_$
--EL OBJETIVO DE LA FUNCION ES CREAR UN ARRAY DE id CON LA TABLA,CODIGOPADRE,CODIGOHIJO,NUM DE CERTIF Y POSICIONES SELECCIONADAS
--SI NO HAY POSICIONES SELECCIONADAS, SE INCLUYEN TODAS LAS LINEAS DE MEDICION CON ESE CODPADRE,CODHIJO Y NURMCERT
DECLARE
    tablamedcert character varying := _nombretabla || '_Mediciones';
    ids integer[];
    id integer;
    m tp_medicion%rowtype;
    pos integer;
BEGIN
IF _posiciones IS NULL THEN
	FOR m in EXECUTE FORMAT ('SELECT * FROM %I WHERE codpadre = $1 AND codhijo = $2 AND num_certif = $3',tablamedcert)	
	USING _codigopadre,_codigohijo,_num_cert LOOP
	RAISE NOTICE 'Meto la posicion: %',pos;
		_posiciones:= array_append(_posiciones,m.posicion);
		END LOOP;
END IF;
--AÑADO id AL ARRAY
FOR I IN array_lower(_posiciones, 1)..array_upper(_posiciones, 1) LOOP
		raise notice 'posicion: %',_posiciones[I];
	EXECUTE FORMAT ('SELECT id FROM %I WHERE codpadre = $1 AND codhijo = $2 AND num_certif = $3 AND posicion = $4', tablamedcert)
		USING _codigopadre,_codigohijo,_num_cert,_posiciones[I] INTO id;
		raise notice 'id: %',id;
	ids:= array_append(ids,id);
	raise notice 'duncion con hijos: % ',ids;
END LOOP;
--LUEGO LLAMO A LA FUNCION
PERFORM borrar_lineas_medcert(_nombretabla,ids,_num_cert,_guardar,_solomedicion);
   END;
$_$;


ALTER FUNCTION public.borrar_lineas_medcert(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _num_cert integer, _posiciones integer[], _guardar boolean, _solomedicion boolean) OWNER TO postgres;

--
-- TOC entry 271 (class 1255 OID 118067)
-- Name: borrar_lineas_principal(character varying, character varying, character varying[], boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.borrar_lineas_principal(_nombretabla character varying, _codigopadre character varying, _codigoshijo character varying[], _guardar boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $_$ 
DECLARE
tablaconceptos character varying := _nombretabla || '_Conceptos';
tablamediciones character varying := _nombretabla || '_Mediciones';
--tablacertificaciones character varying := _nombretabla || '_Certificaciones';
tablarelacion character varying := _nombretabla || '_Relacion';
tablaguardarconceptos character varying := _nombretabla || '_GuardarConceptos';
tablaguardarrelacion character varying := _nombretabla || '_GuardarRelaciones';
tablaguardarmedicion character varying := _nombretabla || '_GuardarMediciones';
tablaguardarcertificacion character varying := _nombretabla || '_GuardarCertificaciones';
existe boolean;
r tp_relacion%ROWTYPE;
c tp_concepto%ROWTYPE;
idmediciones integer[];
arraycodigoshijos character varying[];
indice integer;
solomedicion boolean := false; --false porque la llamo desde la funcion
num_cert integer := NULL;
BEGIN
--CREO LA TABLA DE RELACIONES BORRAR SI RESTAURAR ES TRUE Y NO EXISTE PREVIEMENTE
IF _guardar IS TRUE THEN
	EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF tp_guardarrelacion (PRIMARY KEY (idguardar))',tablaguardarrelacion);
END IF;
--EMPIEZO A EJECUTAR
IF _codigoshijo IS NOT NULL THEN	
	--ITERO SOBRE EL ARRAY DE CODIGOS HIJO
	FOR I IN array_lower(_codigoshijo, 1)..array_upper(_codigoshijo, 1) LOOP
		--METO LA RELACION PADRE HIJO EN LA TABLA DE RELACION EN UN REGISTRO SI RESTAURAR ES TRUE
		IF _guardar IS TRUE THEN
			EXECUTE FORMAT ('SELECT * FROM %I WHERE codpadre = $1 AND codhijo = $2', tablarelacion) INTO r USING _codigopadre, _codigoshijo[I];
			--METO ESE REGISTRO EN LA TABLA DE RELACION BORRAR			
			PERFORM insertar_registro_guardarrelacion(tablaguardarrelacion,NULL,r);
		END IF;
		--BORRO LA RELACION PADRE-HIJO EN LA TABLA ORIGINAL
		EXECUTE FORMAT ('DELETE FROM %I WHERE codpadre = $1 AND codhijo = $2', tablarelacion) USING _codigopadre,_codigoshijo[I];
		--VEO SI QUEDAN MAS HIJOS EN LA TABLA RELACION
		EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM %I WHERE codhijo = $1 )',	tablarelacion) INTO existe USING _codigoshijo[I];
		--SI NO QUEDAN MAS HIJOS:
		IF existe = FALSE THEN
		   --CREO LA TABLA DE CONCEPTOS BORRAR Y METO EL CONCEPTO Y LO BORRO DE LA TABLA DE CONCEPTOS SI restaurar ES TRUE
			IF _guardar IS TRUE THEN
				EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF tp_guardarconcepto (PRIMARY KEY (idguardar))',tablaguardarconceptos);			
				EXECUTE FORMAT ('SELECT * FROM %I WHERE codigo = $1',tablaconceptos) INTO c USING _codigoshijo[I];
				PERFORM insertar_registro_guardarconcepto(tablaguardarconceptos,NULL,c);				
			END IF;
			--BORRO DE LA TABLA DE CONCEPTOS LOS HIJOS QUE CORRESPONDAN
			EXECUTE FORMAT ('DELETE FROM %I WHERE codigo = $1', tablaconceptos) USING _codigoshijo[I];
			--METO LOS HIJOS EN UN ARRAY Y LLAMO DE NUEVO A LA FUNCION
			EXECUTE FORMAT('SELECT array_agg(codhijo) from %I WHERE codpadre = $1',	tablarelacion) INTO arraycodigoshijos USING _codigoshijo[I];
				PERFORM borrar_lineas_principal(_nombretabla,_codigoshijo[I],arraycodigoshijos,_guardar);			
		END IF;
		--AHORA LAS MEDICIONES
		EXECUTE FORMAT('SELECT array_agg(id) from %I WHERE codpadre = $1 AND codhijo = $2', tablamediciones) INTO idmediciones USING _codigopadre,_codigoshijo[I];
		IF idmediciones IS NOT NULL THEN
		    PERFORM borrar_lineas_medcert(_nombretabla,idmediciones,num_cert,_guardar,solomedicion);
		END IF;
		--POR ULTIMO LAS CERTIFICACIONES. EN ESTE CASO PRIMERO MIRO A VER SI EXISTE LA TABLA, PORQUE NO TIENE POR QUE HABERLA SIEMPRE
		--(QUITADO PORQUE YA NO EXISTE LA TABLA DE CERTIFICACIONES)
		/*EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = $1)') INTO existe USING tablacertificaciones;
		IF existe IS TRUE THEN
			EXECUTE format('SELECT array_agg(id) from %I WHERE codpadre = $1 AND codhijo = $2', tablacertificaciones) INTO idcertificaciones
				USING _codigopadre, _codigoshijo[I];
			IF idcertificaciones IS NOT NULL THEN
				PERFORM borrar_lineas_medcert(_nombretabla,idcertificaciones,1,_guardar,solomedicion);--1 porque es la tabla de certificacion
			END IF;
		END IF;*/
		--queda la ordenacion de los elementos restantes
	END LOOP;
END IF;
END;
$_$;


ALTER FUNCTION public.borrar_lineas_principal(_nombretabla character varying, _codigopadre character varying, _codigoshijo character varying[], _guardar boolean) OWNER TO postgres;

--
-- TOC entry 288 (class 1255 OID 115924)
-- Name: borrar_obra(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.borrar_obra(_nombretabla character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
--tablas
tabla_conceptos character varying := _nombretabla || '_Conceptos';
tabla_relacion character varying  := _nombretabla || '_Relacion';
tabla_mediciones character varying := _nombretabla || '_Mediciones';
tabla_guardar_conceptos character varying := _nombretabla || '_GuardarConceptos';
tabla_guardar_relaciones character varying := _nombretabla || '_GuardarRelaciones';
tabla_guardar_mediciones character varying := _nombretabla || '_GuardarMediciones';
tabla_listado_certificaciones character varying := _nombretabla || '_ListadoCertificaciones';
--secuencias
secuencia_relacion character varying := tabla_relacion || '_id_seq';
secuencia_mediciones character varying := tabla_mediciones || '_id_seq';
secuencia_listado_certificaciones character varying := tabla_listado_certificaciones || '_id_seq';
BEGIN
--borrar tablas
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_conceptos);
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_mediciones);
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_relacion);
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_guardar_conceptos);
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_guardar_relaciones);
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_guardar_mediciones);
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_listado_certificaciones);
--borrar secuencias
EXECUTE FORMAT ('DROP SEQUENCE IF EXISTS public.%I',secuencia_relacion);
EXECUTE FORMAT ('DROP SEQUENCE IF EXISTS public.%I',secuencia_mediciones);
EXECUTE FORMAT ('DROP SEQUENCE IF EXISTS public.%I',secuencia_listado_certificaciones);
END;
$$;


ALTER FUNCTION public.borrar_obra(_nombretabla character varying) OWNER TO postgres;

--
-- TOC entry 297 (class 1255 OID 21039)
-- Name: borrar_relacion(character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.borrar_relacion(nombretabla character varying, idpadre integer, idhijo integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  r record;
  pos integer;
  tablarelacion character varying;
  str_null_case character varying;
BEGIN
IF idpadre IS NULL THEN
	str_null_case := ' IS NULL';
ELSE
	str_null_case := ' = '||idpadre;
END IF;
tablarelacion = nombretabla || '_Relacion';
RAISE NOTICE 'Funcion borrar_relacion(%,%,%)',nombretabla,idpadre,idhijo;
EXECUTE FORMAT ('SELECT posicion FROM %I WHERE id_padre %s AND id_hijo = %s',tablarelacion,str_null_case,idhijo) INTO pos;
--pos = (SELECT posicion FROM relacion WHERE id_padre = idpadre AND id_hijo = idhijo);
RAISE NOTICE 'borrar_relacion con % - % en la posicion: %', str_null_case, idhijo, pos;
EXECUTE FORMAT ('DELETE FROM %I WHERE id_padre %s AND id_hijo = %s',tablarelacion,str_null_case,idhijo);
--DELETE FROM relacion WHERE id_padre = idpadre AND id_hijo = idhijo;
--ahora ordeno los hijos
FOR r IN EXECUTE FORMAT ('SELECT * FROM %I WHERE id_padre %s', tablarelacion, str_null_case)
--FOR r IN SELECT * FROM relacion WHERE id_padre = idpadre
	LOOP
	 IF(r.posicion>=pos AND r.id_hijo<>idhijo) THEN
	 	EXECUTE FORMAT ('UPDATE %I SET posicion = %I.posicion-1 WHERE id_hijo = %s',
			tablarelacion, tablarelacion, quote_literal(r.id_hijo));
		RAISE NOTICE 'Ordenar los hijos % que esten despues de la posicion %',r.id_hijo,pos;
	 	
	 END IF;
	END LOOP;
END;
$$;


ALTER FUNCTION public.borrar_relacion(nombretabla character varying, idpadre integer, idhijo integer) OWNER TO postgres;

--
-- TOC entry 329 (class 1255 OID 117793)
-- Name: cambiar_resumen_obra(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.cambiar_resumen_obra(_nombretabla character varying, _resumen character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
--tablas
tabla_conceptos character varying := _nombretabla || '_Conceptos';

BEGIN
EXECUTE FORMAT ('UPDATE %I SET resumen = $1 WHERE codigo = $2', tabla_conceptos) USING _resumen, _nombretabla;
END;
$_$;


ALTER FUNCTION public.cambiar_resumen_obra(_nombretabla character varying, _resumen character varying) OWNER TO postgres;

--
-- TOC entry 258 (class 1255 OID 118766)
-- Name: cerrar_obra(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.cerrar_obra(_nombretabla character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
--tablas
tabla_guardar_conceptos character varying := _nombretabla || '_GuardarConceptos';
tabla_guardar_relaciones character varying := _nombretabla || '_GuardarRelaciones';
tabla_guardar_mediciones character varying := _nombretabla || '_GuardarMediciones';
tabla_guardar_certificaciones character varying := _nombretabla || '_GuardarCertificaciones';
BEGIN
--borrar tablas
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_guardar_conceptos);
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_guardar_relaciones);
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_guardar_mediciones);
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_guardar_certificaciones);
END;
$$;


ALTER FUNCTION public.cerrar_obra(_nombretabla character varying) OWNER TO postgres;

--
-- TOC entry 270 (class 1255 OID 119139)
-- Name: cerrar_tablas_auxiliares(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.cerrar_tablas_auxiliares(_nombretabla character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
--tablas
tabla_guardar_conceptos character varying := _nombretabla || '_GuardarConceptos';
tabla_guardar_relaciones character varying := _nombretabla || '_GuardarRelaciones';
tabla_guardar_mediciones character varying := _nombretabla || '_GuardarMediciones';
tabla_guardar_certificaciones character varying := _nombretabla || '_GuardarCertificaciones';
BEGIN
--borrar tablas
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_guardar_conceptos);
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_guardar_relaciones);
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_guardar_mediciones);
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_guardar_certificaciones);
END;
$$;


ALTER FUNCTION public.cerrar_tablas_auxiliares(_nombretabla character varying) OWNER TO postgres;

--
-- TOC entry 328 (class 1255 OID 116068)
-- Name: certificar(character varying, character varying, character varying, character varying[], integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.certificar(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _indices character varying[], _num_certif integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$ 
DECLARE
tablamedicion character varying := _nombretabla || '_Mediciones';
tablacertificacion character varying := _nombretabla || '_Certificaciones';
fila tp_medicion%rowtype;
existe boolean;
BEGIN
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %L)', tablacertificacion) INTO existe;
IF existe IS FALSE THEN
	RETURN false;
END IF;
--RECORRO EL ARRAY DE INDICES SELECCIONADOS
FOR I IN array_lower(_indices, 1)..array_upper(_indices, 1)
	LOOP
	-- AHORA RECORRO LOS ELEMENTOS DE LA TABLA DE MEDICION SELECCIONADA CON CODIGOPADRE Y CODIGOHIJO DEFINIDOS
	FOR fila in EXECUTE FORMAT('SELECT *, ROW_NUMBER() OVER (ORDER BY id) AS indice FROM %I WHERE codpadre = $1 AND codhijo = $2 ORDER BY id',tablamedicion)
		USING _codigopadre, _codigohijo
		LOOP
			IF fila.posicion = _indices[I]::integer THEN
				RAISE NOTICE 'Comentario: %',fila.comentario;
				fila.num_certif = _num_certif;
				PERFORM insertar_tipo_medcert(_nombretabla,fila,1);
			END IF;
		END LOOP;
END LOOP;
RETURN true;
END;
$_$;


ALTER FUNCTION public.certificar(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _indices character varying[], _num_certif integer) OWNER TO postgres;

--
-- TOC entry 291 (class 1255 OID 94819)
-- Name: copiar(character varying, character varying, character varying[], boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.copiar(_nombretabla character varying, _codigopadre character varying, _codigos character varying[], _primer_paso boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$ 
DECLARE
tablaconceptos character varying := _nombretabla || '_Conceptos';
tablarelacion character varying := _nombretabla || '_Relacion';
tablamedicion character varying := _nombretabla || '_Mediciones';


tablacopiarconceptos character varying := '__CopiarConceptos';
tablacopiarrelacion character varying := '__CopiarRelacion';
tablacopiarmediciones character varying := '__CopiarMediciones';

r tp_relacion%ROWTYPE;
c tp_concepto%ROWTYPE;

existe boolean;
arraycodigoshijos character varying[];

BEGIN
--primer paso, crear las tablas copiar conceptos, relaciones y mediciones y por si ya existieran, borrar su contenido
--Esta operacion solo se realizara en la primera llamada a la funcion
IF _primer_paso IS TRUE THEN
    EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF tp_relacion (PRIMARY KEY (id))',tablacopiarrelacion);
    EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF tp_concepto (PRIMARY KEY (codigo))',tablacopiarconceptos);
    EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF tp_medicion (PRIMARY KEY (id))',tablacopiarmediciones);
    -- Luego se limpiaran por si ya existieran y tuvieran contenido
    EXECUTE FORMAT ('TRUNCATE %I,%I,%I',tablacopiarrelacion,tablacopiarconceptos,tablacopiarmediciones);
END IF;
--segundo paso, recorrer los codigos seleccionados
IF _codigos IS NOT NULL THEN	
	--ITERO SOBRE EL ARRAY DE CODIGOS HIJO
	FOR I IN array_lower(_codigos, 1)..array_upper(_codigos, 1)
	LOOP
		--copio las primeras relaciones
		EXECUTE FORMAT ('INSERT INTO %I	SELECT * FROM %I WHERE codpadre = %L AND codhijo = %L ON CONFLICT DO NOTHING',
							tablacopiarrelacion,
							tablarelacion,
							_codigopadre,
							_codigos[I]);
		--pongo nulos los conceptos raiz
		IF _primer_paso IS TRUE THEN
				EXECUTE FORMAT ('UPDATE %I SET codpadre = NULL WHERE codpadre = %L AND codhijo = %L',
						tablacopiarrelacion,
						_codigopadre,
						_codigos[I]);
		END IF;
		--ahora meto los conceptos
		EXECUTE FORMAT ('INSERT INTO %I	SELECT * FROM %I WHERE codigo = %L ON CONFLICT DO NOTHING',
			tablacopiarconceptos,
			tablaconceptos,
			_codigos[I]);
		--mediciones
		EXECUTE FORMAT ('INSERT INTO %I	SELECT * FROM %I WHERE codpadre = %L AND codhijo = %L ON CONFLICT DO NOTHING',
			tablacopiarmediciones,
			tablamedicion,
			_codigopadre,
			_codigos[I]);		
		--selecciono los hijos de cada hijo y llamo de nuevo a la funcion
		EXECUTE FORMAT('SELECT array_agg(codhijo) from %I WHERE codpadre = %L',
			tablarelacion,_codigos[I]) INTO arraycodigoshijos;
		PERFORM copiar(_nombretabla,_codigos[I], arraycodigoshijos,'FALSE');		
	END LOOP;
END IF;
END;
$$;


ALTER FUNCTION public.copiar(_nombretabla character varying, _codigopadre character varying, _codigos character varying[], _primer_paso boolean) OWNER TO postgres;

--
-- TOC entry 307 (class 1255 OID 139607)
-- Name: copiar_medicion(character varying, character varying, character varying, integer, integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.copiar_medicion(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _num_cert integer, _lineas integer[] DEFAULT NULL::integer[]) RETURNS void
    LANGUAGE plpgsql
    AS $_$ 
DECLARE
tablamedicion character varying := _nombretabla || '_Mediciones';
tablacopiarmediciones character varying := '__CopiarMediciones';
tamanno integer := array_length(_lineas, 1);
BEGIN
--primer paso, crear las tablas copiar conceptos, relaciones y mediciones y por si ya existieran, borrar su contenido
EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF tp_medicion (PRIMARY KEY (id))',tablacopiarmediciones);
-- Luego se limpiara por si ya existiera y tuviera contenido
EXECUTE FORMAT ('TRUNCATE %I',tablacopiarmediciones);
--finalmente, recorrer los codigos seleccionados
--si no hay un listado de lineas seleccionadas se meten todas
IF _lineas IS NULL THEN
	EXECUTE FORMAT ('INSERT INTO %I	SELECT * FROM %I WHERE codpadre = $1 AND codhijo = $2 AND num_certif = $3 ON CONFLICT DO NOTHING',
				tablacopiarmediciones, tablamedicion) USING
				_codigopadre,
				_codigohijo,
				_num_cert;
ELSE
--si hay lineas seleccionadas solo copio esas lineas	
	FOR i IN 1..tamanno LOOP
		EXECUTE FORMAT ('INSERT INTO %I	SELECT * FROM %I WHERE codpadre = $1 AND codhijo = $2 AND num_certif = $3 AND posicion = $4 ON CONFLICT DO NOTHING',
				tablacopiarmediciones, tablamedicion) USING
				_codigopadre,
				_codigohijo,
				_num_cert,
				_lineas[i];
	END LOOP;
END IF;
END;
$_$;


ALTER FUNCTION public.copiar_medicion(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _num_cert integer, _lineas integer[]) OWNER TO postgres;

--
-- TOC entry 311 (class 1255 OID 26129)
-- Name: crear_obra(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.crear_obra(codigo character varying, resumen character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
resultado integer;
tablaconceptos character varying;
tablarelacion character varying;
BEGIN
resultado = (SELECT crear_tabla_conceptos(codigo));
IF resultado != 0 THEN
RETURN resultado;
END IF;
resultado = (SELECT crear_tabla_relacion(codigo));
IF resultado != 0 THEN
RETURN resultado;
END IF;
resultado = (SELECT crear_tabla_mediciones(codigo));
IF resultado != 0 THEN
RETURN resultado;
END IF;
--si todo esta correcto:
tablaconceptos := codigo||'_Conceptos';
tablarelacion := codigo||'_Relacion';
--insertamos el nodo raiz
EXECUTE format ('INSERT INTO %I(codigo,resumen,naturaleza,fecha) VALUES(%s,%s,6,NOW())',tablaconceptos,quote_literal(codigo),quote_literal(resumen));
--insertamos la primera relacion
EXECUTE format ('INSERT INTO %I VALUES(0,NULL,%s,1,1,0)',tablarelacion,quote_literal(codigo));
return 0;
END;
$$;


ALTER FUNCTION public.crear_obra(codigo character varying, resumen character varying) OWNER TO postgres;

--
-- TOC entry 262 (class 1255 OID 68341)
-- Name: crear_tabla_conceptos(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.crear_tabla_conceptos(codigo character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
cadena text;
BEGIN
EXECUTE format ('CREATE TABLE IF NOT EXISTS %I OF tp_concepto (PRIMARY KEY (codigo))',codigo||'_Conceptos');		
RETURN 0;
EXCEPTION 
    WHEN others THEN
        RAISE INFO 'Error Name:%',SQLERRM;
        RAISE INFO 'Error State:%', SQLSTATE;
        RETURN -1;
END;
$$;


ALTER FUNCTION public.crear_tabla_conceptos(codigo character varying) OWNER TO postgres;

--
-- TOC entry 315 (class 1255 OID 27302)
-- Name: crear_tabla_mediciones(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.crear_tabla_mediciones(codigo character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
tablamedicion character varying := codigo||'_Mediciones';
secuencia character varying := tablamedicion||'_id_seq';
BEGIN
EXECUTE format ('CREATE TABLE IF NOT EXISTS %I OF tp_medicion (PRIMARY KEY (id))',tablamedicion);
EXECUTE FORMAT ('CREATE SEQUENCE %I',codigo||'_Mediciones_id_seq');
EXECUTE FORMAT ('ALTER TABLE %I ALTER COLUMN id SET NOT NULL, ALTER COLUMN id SET DEFAULT nextval (''%I''::regclass)',
tablamedicion, secuencia);
RETURN 0;
EXCEPTION 
    WHEN others THEN
        RAISE INFO 'Error Name:%',SQLERRM;
        RAISE INFO 'Error State:%', SQLSTATE;
        RETURN -3;
END;
$$;


ALTER FUNCTION public.crear_tabla_mediciones(codigo character varying) OWNER TO postgres;

--
-- TOC entry 314 (class 1255 OID 27293)
-- Name: crear_tabla_relacion(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.crear_tabla_relacion(codigo character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
tablarelacion character varying;
secuencia character varying;
BEGIN
tablarelacion := codigo||'_Relacion';
secuencia := tablarelacion||'_id_seq';
EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF tp_relacion (PRIMARY KEY (id))',tablarelacion);
EXECUTE FORMAT ('CREATE SEQUENCE %I',codigo||'_Relacion_id_seq');
EXECUTE FORMAT ('ALTER TABLE %I ALTER COLUMN id SET NOT NULL, ALTER COLUMN id SET DEFAULT nextval (''%I''::regclass)',
tablarelacion, secuencia);
RETURN 0;
EXCEPTION 
    WHEN others THEN
        RAISE INFO 'Error Name:%',SQLERRM;
        RAISE INFO 'Error State:%', SQLSTATE;
        RETURN -2;
END;
$$;


ALTER FUNCTION public.crear_tabla_relacion(codigo character varying) OWNER TO postgres;

--
-- TOC entry 313 (class 1255 OID 26373)
-- Name: es_ancestro(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.es_ancestro(nombretabla character varying, codigopadre character varying, codigohijo character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
r character varying;
hayAncestro boolean;
str_null_case character varying;
tablarelacion character varying;
BEGIN
IF codigopadre IS NULL THEN
	str_null_case := ' IS NULL';
ELSE
	str_null_case := ' = '||quote_literal(codigopadre);
END IF;
hayAncestro = false;
tablarelacion := nombretabla||'_Relacion';
--primera comprobacion, que padre e hijo no sean el mismo codigo
IF codigopadre = codigohijo THEN
RETURN true;
END IF;
FOR r in EXECUTE FORMAT('SELECT codpadre FROM %I WHERE codhijo %s',tablarelacion,str_null_case)
LOOP
	RAISE NOTICE 'Estudio el par : %-%',r,codigohijo;
	IF r = codigohijo THEN
	RAISE NOTICE 'Existe la relacion : %-%',codigopadre,codigohijo;
	hayAncestro =  true;
	RAISE NOTICE 'El ancestro recente es: %',HayAncestro;
	RETURN hayAncestro;	
	ELSE
	hayAncestro =  es_ancestro(nombretabla, r, codigohijo);
	END IF;
END LOOP;
RAISE NOTICE 'El ancestro es: %',hayAncestro;
RETURN hayAncestro;
END;
$$;


ALTER FUNCTION public.es_ancestro(nombretabla character varying, codigopadre character varying, codigohijo character varying) OWNER TO postgres;

--
-- TOC entry 327 (class 1255 OID 43477)
-- Name: es_precio_bloqueado(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.es_precio_bloqueado(nombretabla character varying, codigo character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaconceptos character varying := nombretabla || '_Conceptos';
resultado boolean;
BEGIN
EXECUTE FORMAT ('SELECT preciobloq IS NOT NULL FROM %I WHERE codigo = %s',tablaconceptos,quote_literal(codigo)) INTO resultado;
RETURN resultado;
END;
$$;


ALTER FUNCTION public.es_precio_bloqueado(nombretabla character varying, codigo character varying) OWNER TO postgres;

--
-- TOC entry 319 (class 1255 OID 30876)
-- Name: existe_codigo(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.existe_codigo(nombretabla character varying, codigo character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaconceptos character varying;
existe boolean;
BEGIN
tablaconceptos = nombretabla || '_Conceptos';
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM %I WHERE codigo = %s )',
	tablaconceptos , quote_literal(codigo)) INTO existe;
RETURN existe;
END;
$$;


ALTER FUNCTION public.existe_codigo(nombretabla character varying, codigo character varying) OWNER TO postgres;

--
-- TOC entry 309 (class 1255 OID 26370)
-- Name: existe_hermano(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.existe_hermano(nombretabla character varying, codigopadre character varying, codigohijo character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
--r relacion%ROWTYPE;
r character varying;

BEGIN
RAISE NOTICE 'FUNCION EXISTE HERMANO CON %-%-%',nombretabla,codigopadre,codigohijo;
FOR r in EXECUTE FORMAT ('SELECT codhijo FROM %I WHERE codpadre = %s', nombretabla||'_Relacion', codigopadre)
 LOOP
 	--RAISE NOTICE 'Estudio el par : %-%',r,codigohijo;
 	IF quote_literal(r) = codigohijo THEN 	
 	RETURN TRUE;
 	END IF;
 END LOOP;
RETURN FALSE;
END;
$$;


ALTER FUNCTION public.existe_hermano(nombretabla character varying, codigopadre character varying, codigohijo character varying) OWNER TO postgres;

--
-- TOC entry 304 (class 1255 OID 29562)
-- Name: exportarbc3(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.exportarbc3(tabla character varying) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
C record;
D record;
M record;
tablaconceptos character varying;
tablarelacion character varying;
tablamedicion character varying;
haydescomposicion boolean;
haymedicion boolean;
salida text;
cadenamedicion text;
BEGIN
cadenamedicion = '';
tablaconceptos := tabla||'_Conceptos';
tablarelacion := tabla||'_Relacion';
tablamedicion := tabla||'_Mediciones';
--REGISTRO C	
FOR C IN EXECUTE FORMAT ('SELECT codigo, ud, resumen, preciomed, fecha, naturaleza,descripcion FROM %I',tablaconceptos)
	LOOP
	salida := concat (salida,'~C|');
	salida := concat(salida,poner_almohadilla(tabla, C.codigo));salida:=concat(salida,'|');
	salida := concat(salida,C.ud);salida:=concat(salida,'|');
	salida := concat(salida,C.resumen);salida:=concat(salida,'|');
	salida := concat(salida,C.preciomed);salida:=concat(salida,'|');
	salida := concat(salida,fecha_a_bc3(C.fecha));salida:=concat(salida,'|');
	salida := concat(salida,C.naturaleza);salida:=concat(salida,'|');
	salida := concat(salida,chr(10));
	--REGISTRO D
	haydescomposicion = hay_descomposicion(tabla,C.codigo);
	IF haydescomposicion IS TRUE THEN
	    salida := concat (salida,'~D|',poner_almohadilla(tabla, C.codigo),'|');
	END IF;
	FOR D IN EXECUTE FORMAT ('SELECT codhijo, canpres FROM %I WHERE codpadre = %s',tablarelacion, quote_literal(C.codigo))	    
	    LOOP		
		IF haydescomposicion IS TRUE THEN		    		    
		    salida := concat(salida, D.codhijo);salida:=concat(salida,chr(92),'1',chr(92),D.canpres,chr(92));		    
		END IF;
		--AQUI CONSTRUYO LA CADENA DE MEDICION EN CASO DE QUE HAYA
		haymedicion = hay_medcert(tabla,C.codigo,D.codhijo);		
		IF haymedicion IS TRUE THEN
		    cadenamedicion := concat (cadenamedicion,'~M|',poner_almohadilla(tabla, C.codigo),chr(92),D.codhijo,'||',D.canpres,'|');
		    FOR M IN EXECUTE FORMAT('SELECT tipo,comentario,ud,longitud,anchura,altura FROM %I WHERE codpadre = %s AND codhijo = %s AND num_certif = 0',
		    tablamedicion, quote_literal(C.codigo), quote_literal(D.codhijo))
		        LOOP
		            cadenamedicion:=concat(cadenamedicion,M.tipo,'\',M.comentario,'\',M.ud,'\',M.longitud,'\',M.anchura,'\',M.altura,'\');
		        END LOOP;
		    cadenamedicion := concat (cadenamedicion,'|',chr(10));		    
		END IF;
		--FIN DE LA CONSTRUCCION DE LA CADENA DE MEDICION
	    END LOOP;
	IF haydescomposicion IS TRUE THEN
	    salida := concat(salida,'|',chr(10));
	END IF;
	--REGISTRO M	
	IF haymedicion IS TRUE THEN--SI HAY MEDICION AÑADO LA CADENA CREADA ANTERIORMENTE A LA CADENA PRINCIPAL Y LA PONGO A 0
	    salida := concat (salida,cadenamedicion);
	    cadenamedicion := '';	   
	END IF;
	END LOOP;
	--REGISTRO T
	IF (C.descripcion <> '') IS TRUE THEN
	    salida := concat(salida,'~T|',C.descripcion,'|',chr(10));
	END IF;
RAISE NOTICE 'salida %',salida;
RETURN salida;
END;
$$;


ALTER FUNCTION public.exportarbc3(tabla character varying) OWNER TO postgres;

--
-- TOC entry 317 (class 1255 OID 29561)
-- Name: fecha_a_bc3(date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fecha_a_bc3(fecha date) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
fechabc3 character varying;
dia character varying;
mes character varying;
anno character varying;
BEGIN
fechabc3 := fecha::character varying;
dia := substring(fechabc3 from 9 for 2);
mes := substring(fechabc3 from 6 for 2);
anno := substring(fechabc3 from 1 for 4);
fechabc3 := concat(dia,mes,anno);
RETURN fechabc3;
END;
$$;


ALTER FUNCTION public.fecha_a_bc3(fecha date) OWNER TO postgres;

--
-- TOC entry 325 (class 1255 OID 115781)
-- Name: hay_certificacion(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.hay_certificacion(_nombretabla character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$ 
DECLARE
tablacertificacion character varying := _nombretabla || '_Certificaciones';
existe boolean;
BEGIN
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %L)', tablacertificacion) INTO existe;
RETURN existe;
END;
$$;


ALTER FUNCTION public.hay_certificacion(_nombretabla character varying) OWNER TO postgres;

--
-- TOC entry 269 (class 1255 OID 68682)
-- Name: hay_descomposicion(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.hay_descomposicion(_nombretabla character varying, _codigo character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
tablarelacion character varying := _nombretabla || '_Relacion';
resultado boolean;
BEGIN
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM %I WHERE codpadre = %L )',tablarelacion , _codigo) INTO resultado;
RETURN resultado;
END;
$$;


ALTER FUNCTION public.hay_descomposicion(_nombretabla character varying, _codigo character varying) OWNER TO postgres;

--
-- TOC entry 281 (class 1255 OID 119392)
-- Name: hay_medcert(character varying, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.hay_medcert(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _tipocandidad integer DEFAULT 0) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
tablamedcert character varying := _nombretabla||'_Mediciones';
cadenanumcert character varying;
resultado boolean;
--tipocantidad hace referencia a si hablamos de la cantidad presupuestada (canpres) o certificada (cancert) y en funcion de eso buscaremos las 
--lineas de medicion que tengan el num_certif = 0 (las de medicion) o las que sean mayores a esta (las de certificacion)
BEGIN
IF _tipocandidad = 0 THEN 
    cadenanumcert = '= 0';
ELSE
    cadenanumcert = '> 0';
END IF;
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM %I WHERE codpadre = $1 AND codhijo = $2 AND num_certif %s)', tablamedcert, cadenanumcert)
	INTO resultado
	USING _codigopadre, _codigohijo;
RETURN resultado;
END;
$_$;


ALTER FUNCTION public.hay_medcert(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _tipocandidad integer) OWNER TO postgres;

--
-- TOC entry 289 (class 1255 OID 119318)
-- Name: id_por_posicion(character varying, character varying, character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.id_por_posicion(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _posicion integer, _num_cert integer DEFAULT 0) RETURNS integer
    LANGUAGE plpgsql
    AS $_$ 
DECLARE
tablamedcert character varying := _nombretabla || '_Mediciones';
idseleccionado integer;

BEGIN
EXECUTE FORMAT ('SELECT id FROM %I WHERE codpadre = $1 AND codhijo = $2 AND posicion = $3 AND num_certif = $4',tablamedcert) INTO idseleccionado 
	USING _codigopadre,_codigohijo, _posicion, _num_cert;
RETURN idseleccionado;
END;
$_$;


ALTER FUNCTION public.id_por_posicion(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _posicion integer, _num_cert integer) OWNER TO postgres;

--
-- TOC entry 292 (class 1255 OID 119678)
-- Name: insertar_concepto(character varying, character varying, character varying, character varying, text, numeric, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_concepto(nombretabla character varying, codigopadre character varying, u character varying DEFAULT ''::character varying, resumen character varying DEFAULT ''::character varying, texto text DEFAULT ''::text, precio numeric DEFAULT 0, nat integer DEFAULT 7, fecha character varying DEFAULT NULL::character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$

DECLARE
tablaconceptos character varying := nombretabla || '_Conceptos';
--fecha date;
existe boolean;

BEGIN
--fecha = procesar_cadena_fecha(fec);
EXECUTE FORMAT ('SELECT NOT EXISTS (SELECT codigo FROM %I WHERE codigo = %L)', tablaconceptos, codigopadre) INTO existe;
IF existe = TRUE THEN
EXECUTE FORMAT ('INSERT INTO %I (codigo,ud,resumen,descripcion,preciomed,preciocert,naturaleza,fecha) VALUES
		($1,$2,$3,$4,$5,$6,$7,$8)',tablaconceptos)
		USING		
		codigopadre,
		u,
		resumen,
		texto,
		precio,
		precio,
		nat,	
		procesar_cadena_fecha(fecha);
END IF;
END;
$_$;


ALTER FUNCTION public.insertar_concepto(nombretabla character varying, codigopadre character varying, u character varying, resumen character varying, texto text, precio numeric, nat integer, fecha character varying) OWNER TO postgres;

--
-- TOC entry 272 (class 1255 OID 119160)
-- Name: insertar_lineas_medcert(character varying, character varying, character varying, integer, integer, integer, integer, character varying, numeric, numeric, numeric, numeric, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_lineas_medcert(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _num_lineas integer DEFAULT 1, _posicion integer DEFAULT (- (1)::smallint), _num_cert integer DEFAULT 0, _tipo integer DEFAULT 0, _comentario character varying DEFAULT NULL::character varying, _ud numeric DEFAULT (0)::numeric, _longitud numeric DEFAULT (0)::numeric, _anchura numeric DEFAULT (0)::numeric, _altura numeric DEFAULT (0)::numeric, _formula character varying DEFAULT NULL::character varying, _idfila integer DEFAULT NULL::integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
tablamedcert character varying :=_nombretabla || '_Mediciones';
nuevaid integer;
r record;
BEGIN
--defino el tipo si hay formula
IF _formula!= 'NULL' THEN _tipo = 3; END IF;
--tratamos el comentario
IF _comentario = 'NULL' THEN _comentario = ''; END IF;
--iteramos por cada linea insertada (_num_lineas)
FOR i IN 1.._num_lineas LOOP
--ahora ordenar las lineas
FOR r IN EXECUTE FORMAT ('SELECT * FROM ver_medcert(%L,%L,%L,%L)', _nombretabla,_codigopadre,_codigohijo,_num_cert)
LOOP
	IF r.pos>=_posicion THEN
		EXECUTE FORMAT ('UPDATE %I SET posicion = posicion+1 WHERE id = $1', tablamedcert)
		USING r.id;
	END IF;
END LOOP;
--RAISE NOTICE 'INSERTAR EN % LA UD: %, LA LONGITUD %, LA ANCHURA % Y LA ALTURA %', tablamediciones, ud,longitud,anchura,altura;
EXECUTE FORMAT ('INSERT INTO %I (comentario,ud,longitud,anchura,altura,formula,tipo,codpadre,codhijo,posicion,num_certif)
	VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11)',tablamedcert)
USING 
_comentario,
_ud,
_longitud,
_anchura,
_altura,
_formula,
_tipo,
_codigopadre,
_codigohijo,
_posicion,
_num_cert
;

END LOOP;
PERFORM modificar_cantidad(_nombretabla,_codigopadre,_codigohijo);
--ahora hallo la id de la linea recien insertada
EXECUTE FORMAT ('SELECT MAX(id) FROM %I',tablamedcert) INTO nuevaid;
RETURN nuevaid;
END;
$_$;


ALTER FUNCTION public.insertar_lineas_medcert(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _num_lineas integer, _posicion integer, _num_cert integer, _tipo integer, _comentario character varying, _ud numeric, _longitud numeric, _anchura numeric, _altura numeric, _formula character varying, _idfila integer) OWNER TO postgres;

--
-- TOC entry 294 (class 1255 OID 121855)
-- Name: insertar_partida(character varying, character varying, character varying, smallint, numeric, character varying, character varying, text, numeric, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_partida(nombretabla character varying, codigopadre character varying, codigohijo character varying, pos smallint DEFAULT (- (1)::smallint), cantidad numeric DEFAULT 1, u character varying DEFAULT ''::character varying, res character varying DEFAULT ''::character varying, texto text DEFAULT ''::text, precio numeric DEFAULT 0, nat integer DEFAULT 7, fec character varying DEFAULT ''::character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
fechapartida DATE;
eshermano boolean := false;
esancestro boolean := false;
existe boolean;
tablaconceptos character varying := nombretabla||'_Conceptos';
tablarelacion character varying := nombretabla || '_Relacion';
BEGIN
-- lo primero es ver si el hijo ya existe. Si no existe, annadimos el nuevo concepto y su relacion, sin hacer mas comprobaciones
EXECUTE FORMAT ('SELECT EXISTS (SELECT codigo FROM %I WHERE codigo = %L)',tablaconceptos,codigohijo) INTO existe;
IF (existe is FALSE) THEN --si es NULL es que no existe
	RAISE NOTICE 'Creo e inserto nuevo nodo';
	--creo el nuevo concepto (nodo)
	--proceso la fecha
	--fechapartida = procesar_cadena_fecha(fec);
	/*EXECUTE FORMAT('INSERT INTO %I (codigo,ud,resumen,descripcion,naturaleza,preciomed,fecha) 
	VALUES ($1, $2, $3, $4, $5, $6, $7)',tablaconceptos) 
	USING codigohijo, u, res, texto, nat, precio, fechapartida;*/
	EXECUTE FORMAT ('SELECT insertar_concepto($1, $2, $3, $4, $5, $6, $7, $8)') USING nombretabla, codigohijo, u, res, texto, precio, nat, fec;
		
ELSE  --si ya existe hay que hacer comprobaciones de si es padre o referencia circular. Si ocurre alguna
	--de estas dos cosas salimos de la funcion con codigo de error
	--primera comprobacion. Que no exista ya esl codigo bajo ese padre, es decir, que no haya un hermano
	--RAISE NOTICE 'COMPROBAR HERMANOS';
	EXECUTE FORMAT ('SELECT existe_hermano($1,$2,$3)')
	USING
	nombretabla,
	quote_literal(codigopadre),
	quote_literal(codigohijo)
	INTO eshermano;	
	IF eshermano IS TRUE
		THEN RAISE NOTICE 'El codigo % ya tiene un codigo hijo = a %',codigopadre,codigohijo;
		RETURN 1;
	--segunda comprobacion, si no es hermano comprobamos que no haya un ancestro directo con el mcismo codigo
	ELSE
	    EXECUTE FORMAT ('SELECT es_ancestro($1,$2,$3)') 
	    USING
	    nombretabla,
	    quote_literal(codigopadre),
	    quote_literal(codigohijo)
	    INTO esancestro;
	    IF esancestro IS TRUE	    
		THEN RAISE NOTICE 'Hay referencia circular';
		RETURN 2;
	    END IF;
	END IF;
END IF;
--RAISE NOTICE 'HE LLEGADO HASTA AQUI y voy con la cantidad: %',cantidad;
PERFORM insertar_relacion(nombretabla, codigopadre, codigohijo, cantidad, pos);
PERFORM actualizar_desde_nodo(nombretabla,codigopadre);
RETURN 0;
END;
$_$;


ALTER FUNCTION public.insertar_partida(nombretabla character varying, codigopadre character varying, codigohijo character varying, pos smallint, cantidad numeric, u character varying, res character varying, texto text, precio numeric, nat integer, fec character varying) OWNER TO postgres;

--
-- TOC entry 276 (class 1255 OID 118253)
-- Name: insertar_registro_guardarconcepto(character varying, integer, public.tp_concepto); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_registro_guardarconcepto(_nombretabla character varying, _paso integer, _dato public.tp_concepto) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
BEGIN
EXECUTE FORMAT ('INSERT INTO %I VALUES
	(CASE WHEN (SELECT MAX(idguardar) FROM %I) IS NULL THEN 0 ELSE (SELECT MAX(idguardar)+1 FROM %I) END,$1,$2)',_nombretabla,_nombretabla,_nombretabla) USING
	_paso,	
	_dato
	;
END;
$_$;


ALTER FUNCTION public.insertar_registro_guardarconcepto(_nombretabla character varying, _paso integer, _dato public.tp_concepto) OWNER TO postgres;

--
-- TOC entry 333 (class 1255 OID 117880)
-- Name: insertar_registro_guardarmedicion(character varying, integer, public.tp_medicion); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_registro_guardarmedicion(_nombretabla character varying, _paso integer, _dato public.tp_medicion) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
BEGIN
EXECUTE FORMAT ('INSERT INTO %I VALUES
        (CASE WHEN (SELECT MAX(idguardar) FROM %I) IS NULL THEN 0 ELSE (SELECT MAX(idguardar)+1 FROM %I) END, $1, $2)',_nombretabla,_nombretabla,_nombretabla)
	USING 
	_paso,        
        _dato;  
END;
$_$;


ALTER FUNCTION public.insertar_registro_guardarmedicion(_nombretabla character varying, _paso integer, _dato public.tp_medicion) OWNER TO postgres;

--
-- TOC entry 273 (class 1255 OID 118252)
-- Name: insertar_registro_guardarrelacion(character varying, integer, public.tp_relacion); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_registro_guardarrelacion(_nombretabla character varying, _paso integer, _dato public.tp_relacion) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
BEGIN
EXECUTE FORMAT ('INSERT INTO %I VALUES(
	CASE WHEN (SELECT MAX(idguardar) FROM %I) IS NULL THEN 0 ELSE (SELECT MAX(idguardar)+1 FROM %I) END,$1,$2)',_nombretabla,_nombretabla,_nombretabla) USING
	_paso,	
	_dato;	
END;
$_$;


ALTER FUNCTION public.insertar_registro_guardarrelacion(_nombretabla character varying, _paso integer, _dato public.tp_relacion) OWNER TO postgres;

--
-- TOC entry 279 (class 1255 OID 77539)
-- Name: insertar_registro_relacion(character varying, integer, public.tp_relacion); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_registro_relacion(_nombretabla character varying, _paso integer, _dato public.tp_relacion) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
EXECUTE FORMAT ('INSERT INTO %I VALUES(
	CASE WHEN (SELECT MAX(idborrar) FROM %I) IS NULL THEN 0 ELSE (SELECT MAX(idborrar)+1 FROM %I) END,
	%L,
	(%L,%L,%L,%L,%L,%L))',_nombretabla,_nombretabla,_nombretabla,
	_paso,
	_dato.id,
	_dato.codpadre,
	_dato.codhijo,
	_dato.canpres,
	COALESCE(_dato.cancert,0),
	_dato.posicion
	);
END;
$$;


ALTER FUNCTION public.insertar_registro_relacion(_nombretabla character varying, _paso integer, _dato public.tp_relacion) OWNER TO postgres;

--
-- TOC entry 322 (class 1255 OID 115233)
-- Name: insertar_relacion(character varying, character varying, character varying, numeric, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_relacion(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _cantidad numeric, _pos smallint) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
r record;
tablarelacion character varying := _nombretabla||'_Relacion';
  
BEGIN
--RAISE NOTICE 'insertar_relacion con % - % en la posicion: % y cantidad: %',codigopadre,codigohijo,pos,cantidad;
EXECUTE FORMAT ('INSERT INTO %I (codpadre,codhijo,canpres,cancert,posicion) VALUES($1,$2,$3,$4,$5)', tablarelacion)
USING 
_codigopadre,
_codigohijo,
_cantidad,
_cantidad,
_pos;

--ahora ordeno los hijos
IF _pos = -1 THEN	
	EXECUTE FORMAT ('UPDATE %I SET posicion = (SELECT MAX(posicion)+1 FROM %I WHERE codpadre = $1) WHERE codpadre = $2 AND codhijo = $3',
	tablarelacion,tablarelacion)
	USING
	_codigopadre,
	_codigopadre,
	_codigohijo;		 
ELSE 
	FOR r IN EXECUTE FORMAT ('SELECT * FROM %I WHERE codpadre = %L', tablarelacion, _codigopadre)
		LOOP
			--RAISE NOTICE 'Listado: %- %- %- % - %', r.id, r.codpadre, r.codhijo, r.canpres, r.posicion;
			IF(r.posicion>=_pos AND r.codhijo!=_codigohijo) THEN
				EXECUTE FORMAT ('UPDATE %I SET posicion = %I.posicion+1 WHERE codhijo = %L',
				tablarelacion, tablarelacion,
				r.codhijo);
				--RAISE NOTICE 'Ordenar los hijos % que esten despues de la posicion %',r.codhijo,pos;
			END IF;
		END LOOP;
END IF;
END;
$_$;


ALTER FUNCTION public.insertar_relacion(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _cantidad numeric, _pos smallint) OWNER TO postgres;

--
-- TOC entry 267 (class 1255 OID 68663)
-- Name: insertar_texto(character varying, character varying, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_texto(_nombretabla character varying, _cod character varying, _texto text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaconceptos character varying := _nombretabla||'_Conceptos';
BEGIN
EXECUTE FORMAT ('UPDATE %I SET descripcion = %L WHERE codigo = %L',tablaconceptos,_texto,_cod);
EXECUTE FORMAT ('UPDATE %I SET descripcionhtml = %L WHERE codigo = %L',tablaconceptos,_texto,_cod);

END;
$$;


ALTER FUNCTION public.insertar_texto(_nombretabla character varying, _cod character varying, _texto text) OWNER TO postgres;

--
-- TOC entry 301 (class 1255 OID 113848)
-- Name: insertar_tipo_concepto(character varying, public.tp_concepto); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_tipo_concepto(nombretabla character varying, _dato public.tp_concepto) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
tablaconceptos character varying := nombretabla || '_Conceptos';
existe boolean := true;
BEGIN
EXECUTE FORMAT ('SELECT EXISTS (SELECT codigo FROM %I WHERE codigo = %L)', tablaconceptos, _dato.codigo) INTO existe;
IF existe = FALSE THEN
	EXECUTE FORMAT ('INSERT INTO %I (codigo,resumen,descripcion,descripcionhtml,preciomed,preciobloq,naturaleza,fecha,ud,preciocert) VALUES
			($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)',tablaconceptos)
			USING		
			_dato.codigo,
			_dato.resumen,
			COALESCE(_dato.descripcion,''),
			COALESCE(_dato.descripcionhtml,''),
			_dato.preciomed,
			_dato.preciobloq,
			_dato.naturaleza,
			_dato.fecha,
			COALESCE(_dato.ud,''),
			_dato.preciocert
			;	
END IF;
RETURN existe;
END;
$_$;


ALTER FUNCTION public.insertar_tipo_concepto(nombretabla character varying, _dato public.tp_concepto) OWNER TO postgres;

--
-- TOC entry 287 (class 1255 OID 119273)
-- Name: insertar_tipo_medcert(character varying, public.tp_medicion, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_tipo_medcert(_nombretabla character varying, _dato public.tp_medicion, _num_cert integer DEFAULT 0) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
tablamedcert character varying := _nombretabla||'_Mediciones';
existe boolean := true;
r record;
codigopadre character varying := _dato.codpadre;
codigohijo character varying := _dato.codhijo;
posicion integer := _dato.posicion;
BEGIN
--ordenar las lineas
FOR r IN EXECUTE FORMAT ('SELECT * FROM ver_medcert($1,$2,$3,$4)') USING _nombretabla,codigopadre,codigohijo,_num_cert 
LOOP
	IF r.pos>=posicion THEN
		EXECUTE FORMAT ('UPDATE %I SET posicion = posicion+1 WHERE id = $1', tablamedcert)
		USING r.id;
	END IF;
END LOOP;
/*RAISE NOTICE 'INSERTAR TIPO MEDICION %-%-%-%-%-%-%-%-%-%-%-%',_dato.id,_dato.tipo,_dato.comentario,_dato.ud,_dato.longitud,_dato.anchura,_dato.altura,
		_dato.formula,_dato.codpadre,_dato.codhijo,_dato.posicion,_dato.num_certif;*/
EXECUTE FORMAT ('INSERT INTO %I VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12)',tablamedcert)
	USING
	_dato.id,
	COALESCE(_dato.num_certif,NULL),
	COALESCE(_dato.tipo,NULL),
	COALESCE(_dato.comentario,''),
	COALESCE(_dato.ud,NULL),
	COALESCE(_dato.longitud,NULL),
	COALESCE(_dato.anchura,NULL),
	COALESCE(_dato.altura,NULL),	
	COALESCE(_dato.formula,''),
	_dato.codpadre::character varying,
	_dato.codhijo::character varying,				
	COALESCE(_dato.posicion,NULL)
	;
RETURN existe;
END;
$_$;


ALTER FUNCTION public.insertar_tipo_medcert(_nombretabla character varying, _dato public.tp_medicion, _num_cert integer) OWNER TO postgres;

--
-- TOC entry 303 (class 1255 OID 113885)
-- Name: insertar_tipo_relacion(character varying, public.tp_relacion); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_tipo_relacion(_nombretabla character varying, _dato public.tp_relacion) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
tablarelacion character varying := _nombretabla || '_Relacion';
existe boolean := true;
BEGIN
--EXECUTE FORMAT ('SELECT EXISTS (SELECT codigo FROM %I WHERE codigo = %L)', tablaconceptos, _dato.codigo) INTO existe;
--IF existe = FALSE THEN
	EXECUTE FORMAT ('INSERT INTO %I VALUES($1,$2,$3,$4,$5,$6)',tablarelacion)
	USING
	_dato.id,
	_dato.codpadre,
	_dato.codhijo,
	_dato.canpres,
	COALESCE(_dato.cancert,0),
	_dato.posicion
	;
--END IF;
RETURN existe;
END;
$_$;


ALTER FUNCTION public.insertar_tipo_relacion(_nombretabla character varying, _dato public.tp_relacion) OWNER TO postgres;

--
-- TOC entry 308 (class 1255 OID 119337)
-- Name: modificar_campo_medcert(character varying, character varying, character varying, character varying, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.modificar_campo_medcert(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _valor character varying, _idfila integer, _columna integer, _num_cert integer DEFAULT 0) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
tablamedcert character varying := _nombretabla||'_Mediciones';
texto text;
BEGIN
IF (_columna!=1 AND _valor = '') THEN _valor =0;END IF;
CASE _columna
WHEN 1 THEN texto := ' comentario = '||quote_literal(_valor);
WHEN 2 THEN texto := ' ud = '||quote_literal(_valor);
WHEN 3 THEN texto := ' longitud = '||quote_literal(_valor);
WHEN 4 THEN texto := ' anchura = '||quote_literal(_valor);
WHEN 5 THEN texto := ' altura = '||quote_literal(_valor);
WHEN 8 THEN texto := ' tipo = '||quote_literal(_valor);--8 por la posicion de la columna de subtotal
END CASE;
raise notice 'text: %, id: %',texto,_idfila;
EXECUTE FORMAT ('UPDATE %I SET %s WHERE id = %s',tablamedcert, texto, _idfila);
IF _columna = 2 or _columna = 3 or _columna = 4 or _columna = 5 THEN
	PERFORM modificar_cantidad(_nombretabla,_codigopadre,_codigohijo,_num_cert);
END IF;
END;
$$;


ALTER FUNCTION public.modificar_campo_medcert(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _valor character varying, _idfila integer, _columna integer, _num_cert integer) OWNER TO postgres;

--
-- TOC entry 306 (class 1255 OID 139493)
-- Name: modificar_cantidad(character varying, character varying, character varying, integer, boolean, numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.modificar_cantidad(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _num_cert integer DEFAULT 0, _guardar boolean DEFAULT true, _cantidad numeric DEFAULT NULL::numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
tablarelacion character varying := _nombretabla||'_Relacion';
tablamedcert character varying := _nombretabla||'_Mediciones';
nuevacantidad numeric = 0;
tipocantidad character varying;
indices int[];
certificaciones integer;
haymedicion boolean := false;
BEGIN
IF _num_cert = 0 THEN    
    tipocantidad := 'canpres';
ELSE    
    tipocantidad := 'cancert';
END IF;
--si la cantidad no es nula tengo que borrar todas las lineas de medicion y sustituir la cantidad por la cantidad dada
IF _cantidad IS NOT NULL THEN
    raise notice 'entro en la funcion con una cantidad dada: %',_cantidad;
    --guardo los indices de las lineas de medicion de esa partida (si los hubiera)
    EXECUTE FORMAT ('SELECT array_agg(id) FROM %I WHERE codpadre = $1 AND codhijo = $2 AND num_certif = $3' , tablamedcert) 
	INTO indices 
	USING _codigopadre, _codigohijo, _num_cert;
    IF array_length(indices,1)>0 THEN
	haymedicion = true;
    END IF;
    --borro las posibles lineas de medicion
    PERFORM borrar_lineas_medcert(_nombretabla, indices,_num_cert,_guardar,'t');
    --sustituyo la cantidad. 
    nuevacantidad = _cantidad;
--si el argumento de cantidad es nulo, la calculo a partir de sus mediciones
ELSE
    IF _num_cert = 0 THEN --cuando estamos en la tabla de medicion
	EXECUTE FORMAT('SELECT SUM(parcial) FROM ver_medcert($1,$2,$3,$4)') INTO nuevacantidad USING _nombretabla, _codigopadre, _codigohijo, _num_cert;
    ELSE 
	EXECUTE FORMAT('SELECT SUM(parcial) FROM ver_todas_certificaciones($1,$2,$3)') INTO nuevacantidad USING _nombretabla, _codigopadre, _codigohijo;
    END IF;
    
    IF nuevacantidad IS NULL THEN nuevacantidad =0; END IF;
END IF;
--por ultimo cambio la cantidad y recalculo el total
--raise notice 'poner cantidad: % en padre % e hijo %',nuevacantidad, _codigopadre, _codigohijo;
EXECUTE FORMAT ('UPDATE %I SET %s = $1 WHERE codpadre = $2 AND codhijo = $3', tablarelacion, tipocantidad) USING nuevacantidad, _codigopadre, _codigohijo;
--IF existe_codigo(_nombretabla,_codigohijo) THEN
IF COALESCE(_codigohijo,'') IS NOT NULL THEN
    PERFORM actualizar_desde_nodo(_nombretabla,_codigohijo,_num_cert);
END IF;
RETURN haymedicion;
END;
$_$;


ALTER FUNCTION public.modificar_cantidad(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _num_cert integer, _guardar boolean, _cantidad numeric) OWNER TO postgres;

--
-- TOC entry 263 (class 1255 OID 68664)
-- Name: modificar_codigo(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.modificar_codigo(_nombretabla character varying, _codigoantiguo character varying, _codigonuevo character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaconceptos character varying := _nombretabla||'_Conceptos';
tablarelacion character varying := _nombretabla||'_Relacion';
existe boolean;
BEGIN
EXECUTE FORMAT ('SELECT EXISTS(SELECT codigo FROM %I WHERE codigo = %L)',tablaconceptos, _codigonuevo) INTO existe;
IF existe IS FALSE THEN
    EXECUTE FORMAT ('UPDATE %I SET codigo = %L WHERE codigo = %L',tablaconceptos,_codigonuevo, _codigoantiguo);
    EXECUTE FORMAT ('UPDATE %I SET codpadre = %L WHERE codpadre = %L',tablarelacion,_codigonuevo, _codigoantiguo);
    EXECUTE FORMAT ('UPDATE %I SET codhijo = %L WHERE codhijo = %L',tablarelacion,_codigonuevo, _codigoantiguo);
END IF;
RETURN existe;
END;
$$;


ALTER FUNCTION public.modificar_codigo(_nombretabla character varying, _codigoantiguo character varying, _codigonuevo character varying) OWNER TO postgres;

--
-- TOC entry 265 (class 1255 OID 68665)
-- Name: modificar_naturaleza(character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.modificar_naturaleza(_nombretabla character varying, _cod character varying, _nat integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaconceptos character varying := _nombretabla||'_Conceptos';
BEGIN
EXECUTE FORMAT ('UPDATE %I SET naturaleza = %s WHERE codigo = %L', tablaconceptos, _nat , _cod);
END;  
$$;


ALTER FUNCTION public.modificar_naturaleza(_nombretabla character varying, _cod character varying, _nat integer) OWNER TO postgres;

--
-- TOC entry 321 (class 1255 OID 42060)
-- Name: modificar_precio(character varying, character varying, character varying, numeric, integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.modificar_precio(nombretabla character varying, codpadre character varying, codhijo character varying, precio numeric, opcion integer, restaurar boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaborrarconceptos character varying;
tablaborrarrelacion character varying;
BEGIN
tablaborrarconceptos = nombretabla || '_BorrarConceptos';
tablaborrarrelacion = nombretabla || '_BorrarRelacion';
IF opcion = 2 THEN--bloquear el precio
	PERFORM bloquear_precio(nombretabla,codhijo,precio,restaurar);
ELSE
	IF restaurar IS TRUE THEN
		PERFORM borrar_hijos(nombretabla,codhijo);
	ELSE
		PERFORM restaurar_lineas_borradas(nombretabla);
	END IF;	
	--por ultimo actualizo el campo precio	
	EXECUTE FORMAT ('UPDATE %I SET preciomed = %s WHERE codigo=%s',nombretabla||'_Conceptos',quote_literal(precio),quote_literal(codhijo));	
	EXECUTE FORMAT ('UPDATE %I SET preciocert = %s WHERE codigo=%s',nombretabla||'_Conceptos',quote_literal(precio),quote_literal(codhijo));	
END IF;
PERFORM actualizar_desde_nodo(nombretabla,codhijo);
END;
$$;


ALTER FUNCTION public.modificar_precio(nombretabla character varying, codpadre character varying, codhijo character varying, precio numeric, opcion integer, restaurar boolean) OWNER TO postgres;

--
-- TOC entry 268 (class 1255 OID 68662)
-- Name: modificar_resumen(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.modificar_resumen(_nombretabla character varying, _cod character varying, _res character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaconceptos character varying := _nombretabla||'_Conceptos';
BEGIN
EXECUTE FORMAT ('UPDATE %I SET resumen = %L WHERE codigo = %L', tablaconceptos,_res,_cod);
END;
$$;


ALTER FUNCTION public.modificar_resumen(_nombretabla character varying, _cod character varying, _res character varying) OWNER TO postgres;

--
-- TOC entry 261 (class 1255 OID 68610)
-- Name: modificar_texto(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.modificar_texto(nombretabla character varying, cod character varying, textoplano character varying, textohtml character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN

EXECUTE FORMAT ('UPDATE %I SET descripcion = %s WHERE codigo = %s',nombretabla||'_Conceptos' ,quote_literal(textoplano),quote_literal(cod));
EXECUTE FORMAT ('UPDATE %I SET descripcionhtml = %s WHERE codigo = %s',nombretabla||'_Conceptos' ,quote_literal(textohtml),quote_literal(cod));
END;
$$;


ALTER FUNCTION public.modificar_texto(nombretabla character varying, cod character varying, textoplano character varying, textohtml character varying) OWNER TO postgres;

--
-- TOC entry 266 (class 1255 OID 68661)
-- Name: modificar_unidad(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.modificar_unidad(_nombretabla character varying, _cod character varying, _ud character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN
EXECUTE FORMAT ('UPDATE %I SET ud = %L WHERE codigo = %L',_nombretabla||'_Conceptos' ,_ud,_cod);

END;
$$;


ALTER FUNCTION public.modificar_unidad(_nombretabla character varying, _cod character varying, _ud character varying) OWNER TO postgres;

--
-- TOC entry 264 (class 1255 OID 68652)
-- Name: mostrar_ruta(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mostrar_ruta(tabla character varying, codigo character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
existe boolean;
tablarelacion character varying := tabla || '_Relacion';
codigopadre character varying;
ruta character varying := $2;
BEGIN
EXECUTE FORMAT ('SELECT codpadre FROM %I WHERE codhijo = %L', tablarelacion , codigo) INTO codigopadre;
--SI NO ESTAMOS EN EL NODO RAIZ:
/*IF codigopadre IS NOT NULL THEN
	EXECUTE FORMAT('SELECT mostrar_ruta(%I,%L)',tabla,codigopadre);*/
ruta := ruta || '/' || codigopadre;
--END IF;
RETURN ruta;
END;
$_$;


ALTER FUNCTION public.mostrar_ruta(tabla character varying, codigo character varying) OWNER TO postgres;

--
-- TOC entry 295 (class 1255 OID 112965)
-- Name: pegar(character varying, character varying, smallint, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.pegar(_nombretabla character varying, _codigodestino character varying, OUT nodos_insertados character varying, _pos smallint DEFAULT (- (1)::smallint), _primer_paso boolean DEFAULT true) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$ 
DECLARE
R tp_relacion%ROWTYPE;
C tp_concepto%ROWTYPE;
M tp_medicion%ROWTYPE;
tablacopiar character varying := '__CopiarRelacion';
tablaconceptos character varying :='__CopiarConceptos';
tablacopiarmediciones character varying := '__CopiarMediciones';
codpadre character varying;
resultado integer;
posicion smallint := _pos;
existe boolean;
existe_concepto boolean;
BEGIN
nodos_insertados :='';
IF _primer_paso IS TRUE THEN
	codpadre := ' IS NULL';
	_primer_paso := FALSE;
ELSE
	codpadre := ' = '||quote_literal(_codigodestino);	
END IF;
FOR R IN EXECUTE FORMAT ('SELECT * FROM %I WHERE codpadre %s ORDER BY posicion',tablacopiar,codpadre)
LOOP
	--insertar el concepto (solo lo hara si no existe en la tabla. ademas retornara falso si no existia)
	EXECUTE FORMAT ('SELECT * FROM %I WHERE codigo = %L',tablaconceptos,R.codhijo) INTO C;	
	EXECUTE FORMAT ('SELECT insertar_tipo_concepto($1,$2)') USING _nombretabla, C INTO existe_concepto;	
	--insertar la partida (se insertará la relacion, el concepto se ha hecho anteriormente)
	SELECT insertar_partida(_nombretabla,_codigodestino,R.codhijo,posicion,R.canpres) INTO resultado;
	posicion = posicion +1;
	--Solo si no existia el concepto insertado seguimos adelante con las ediciones e hijos de ese concepto.
	IF resultado = 0 THEN
		FOR M IN EXECUTE FORMAT('SELECT * FROM %I WHERE codpadre %s AND codhijo = %L',tablacopiarmediciones,codpadre,R.codhijo) LOOP
			PERFORM insertar_lineas_medcert(_nombretabla,_codigodestino,R.codhijo,1,M.posicion,M.num_certif,M.tipo,M.comentario,M.ud,M.longitud,M.anchura,M.altura,M.formula);
			--PERFORM insertar_tipo_medcert(_nombretabla,M,'0');--tabla mediciones
			--PERFORM insertar_tipo_medcert(_nombretabla,M,'1');--tabla certificaciones
		END LOOP;
	END IF;
	IF existe_concepto IS FALSE THEN	
		nodos_insertados := nodos_insertados || C.codigo||',';
		RAISE NOTICE 'LOS NODOS SON: %' ,C.codigo;
		
		--ver si cada conceptos insertado tiene hijos
		EXECUTE FORMAT ('SELECT EXISTS (SELECT codhijo FROM %I WHERE codpadre = %L)', tablacopiar, R.codhijo) INTO existe;
		IF existe IS TRUE THEN 
			PERFORM pegar(_nombretabla,R.codhijo,'0',_primer_paso);
		END IF;
	END IF;
END LOOP;
nodos_insertados := left(nodos_insertados,-1);
END;
$_$;


ALTER FUNCTION public.pegar(_nombretabla character varying, _codigodestino character varying, OUT nodos_insertados character varying, _pos smallint, _primer_paso boolean) OWNER TO postgres;

--
-- TOC entry 316 (class 1255 OID 139735)
-- Name: pegar_medicion(character varying, character varying, character varying, integer, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.pegar_medicion(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _num_cert integer DEFAULT 0, _pos smallint DEFAULT (- (1)::smallint)) RETURNS character varying[]
    LANGUAGE plpgsql
    AS $$ 
DECLARE
M tp_medicion%ROWTYPE;
tablacopiarmediciones character varying := '__CopiarMediciones';
posicion smallint := _pos;
id character varying;
listaIds character varying[];
BEGIN
FOR M IN EXECUTE FORMAT('SELECT * FROM %I',tablacopiarmediciones) LOOP
	PERFORM insertar_lineas_medcert(_nombretabla,_codigopadre,_codigohijo,1,posicion,_num_cert,M.tipo,M.comentario,M.ud,M.longitud,M.anchura,M.altura,M.formula);	
	listaIds := array_append (listaIds,public.id_por_posicion(_nombretabla,_codigopadre,_codigohijo,posicion,_num_cert)::character varying);
	posicion = posicion +1;	
	END LOOP;
RETURN listaIds;
END;
$$;


ALTER FUNCTION public.pegar_medicion(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _num_cert integer, _pos smallint) OWNER TO postgres;

--
-- TOC entry 318 (class 1255 OID 29560)
-- Name: poner_almohadilla(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.poner_almohadilla(tabla character varying, codigo character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
tablarelacion character varying;
r record;
padre character varying;
abuelo character varying;
nuevocodigo character varying;
BEGIN
nuevocodigo = codigo;
tablarelacion := tabla||'_Relacion';
EXECUTE FORMAT ('SELECT codpadre FROM %I WHERE codhijo = %s',tablarelacion, quote_literal(codigo)) INTO padre;
IF padre IS NULL THEN
    nuevocodigo := concat(codigo,'##');
ELSE
    EXECUTE FORMAT ('SELECT codpadre FROM %I WHERE codhijo = %s',tablarelacion, quote_literal(padre)) INTO abuelo;
    IF abuelo IS NULL THEN
        nuevocodigo := concat(codigo,'#');
    END IF;
END IF;
RETURN nuevocodigo;
END;
$$;


ALTER FUNCTION public.poner_almohadilla(tabla character varying, codigo character varying) OWNER TO postgres;

--
-- TOC entry 296 (class 1255 OID 21024)
-- Name: procesar_cadena_fecha(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.procesar_cadena_fecha(cadenafecha character varying DEFAULT ''::character varying) RETURNS date
    LANGUAGE plpgsql
    AS $_$
DECLARE
fecha DATE;

BEGIN
--comprobacion de si hay digitos. Si no son todos digitos se retorna fecha actual
IF cadenafecha ~ '^(-)?[0-9]+$' IS NOT TRUE THEN
   fecha = NOW();
--empezamos definiendo la fecha
ELSIF char_length(cadenafecha) = 6 THEN 
   fecha = to_date(cadenafecha,'DDMMYY');
ELSIF char_length(cadenafecha) = 8 THEN 
   fecha = to_date(cadenafecha,'DDMMYYYY');
ELSE
   fecha = NOW();
END IF;
RETURN fecha;
END;
$_$;


ALTER FUNCTION public.procesar_cadena_fecha(cadenafecha character varying) OWNER TO postgres;

--
-- TOC entry 300 (class 1255 OID 22185)
-- Name: procesar_linea_medicion(numeric, numeric, numeric, numeric, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.procesar_linea_medicion(unidad numeric, longitud numeric, anchura numeric, altura numeric, formula character varying) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
IF unidad IS NULL THEN unidad = 0; END IF;
IF longitud IS NULL OR longitud = 0 THEN longitud =1; END IF;
IF anchura IS NULL OR anchura = 0 THEN anchura =1; END IF;
IF altura IS NULL OR altura = 0 THEN altura =1; END IF;
RETURN unidad*longitud*anchura*altura;
END;
$$;


ALTER FUNCTION public.procesar_linea_medicion(unidad numeric, longitud numeric, anchura numeric, altura numeric, formula character varying) OWNER TO postgres;

--
-- TOC entry 331 (class 1255 OID 59884)
-- Name: recorrer_principal(character varying, character varying, integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.recorrer_principal(nombretabla character varying, codigopadre character varying DEFAULT NULL::character varying, _nivel integer DEFAULT 0, primer_elemento boolean DEFAULT true) RETURNS TABLE(codigo character varying, naturaleza integer, ud character varying, resumen character varying, preciomed numeric, nivel integer)
    LANGUAGE plpgsql
    AS $$ 
DECLARE
tablaconceptos character varying := nombretabla || '_Conceptos';
tablarelacion character varying := nombretabla || '_Relacion';
existe boolean;
nombre_codigo character varying;
codpadre character varying := codigopadre;
c tp_concepto%ROWTYPE;
indice integer;
str_null_case character varying;
BEGIN
IF (codigopadre = '') IS NOT FALSE THEN
	str_null_case := ' IS NULL';	
ELSE
	str_null_case := ' = '||quote_literal(codigopadre);
END IF;
--ELEMENTO RAIZ
IF primer_elemento IS TRUE THEN
	EXECUTE FORMAT ('SELECT codhijo FROM %I WHERE codpadre %s',tablarelacion,str_null_case) INTO nombre_codigo;
	EXECUTE FORMAT ('SELECT * FROM %I WHERE codigo = %s',tablaconceptos, quote_literal(nombre_codigo)) INTO c;
	codigo := c.codigo;
	nivel := _nivel;
	ud := c.ud;
	naturaleza := c.naturaleza;
	resumen := c.resumen;
	preciomed := c.preciomed;
	RETURN NEXT;
	codpadre := c.codigo;--si es el primer nivel cambio codpadre a este en lugar de al parametro de la funcion
END IF;
--EMPIEZO A ITERAR
FOR nombre_codigo in EXECUTE FORMAT ('SELECT codhijo FROM %I WHERE codpadre = %s', tablarelacion, quote_literal(codpadre))
LOOP
 	EXECUTE FORMAT ('SELECT * FROM %I WHERE codigo = %s', tablaconceptos, quote_literal(nombre_codigo)) INTO c;
	codigo := nombre_codigo;
	nivel := _nivel+1;
	ud := c.ud;
	naturaleza := c.naturaleza;
	resumen := c.resumen;
	preciomed := c.preciomed;
	RETURN NEXT;
	EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM %I WHERE codpadre = %s )', tablarelacion , quote_literal(nombre_codigo)) INTO existe;
	--SI QUEDAN MAS HIJOS:	
	IF existe = TRUE THEN
		RETURN QUERY SELECT * FROM recorrer_principal(nombretabla,nombre_codigo,nivel,'false');				
	END IF;	
 END LOOP;
END;
$$;


ALTER FUNCTION public.recorrer_principal(nombretabla character varying, codigopadre character varying, _nivel integer, primer_elemento boolean) OWNER TO postgres;

--
-- TOC entry 330 (class 1255 OID 112040)
-- Name: restaurar_lineas_borradas(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.restaurar_lineas_borradas(_nombretabla character varying, _tipotabla integer DEFAULT 0) RETURNS void
    LANGUAGE plpgsql
    AS $_$ 
DECLARE
num_paso integer;
tablaconceptos character varying := _nombretabla || '_Conceptos';
tablarelacion character varying := _nombretabla || '_Relacion';
tablamedicion character varying := _nombretabla || '_Mediciones';
tablaguardarconceptos character varying := _nombretabla || '_GuardarConceptos';
tablaguardarrelacion character varying := _nombretabla || '_GuardarRelaciones';
tablaguardarmedicion character varying := _nombretabla || '_GuardarMediciones';
existe boolean;

c tp_concepto%ROWTYPE;
cg tp_guardarconcepto%ROWTYPE;
r tp_relacion%ROWTYPE;
rg tp_guardarrelacion%ROWTYPE;
m tp_medicion%ROWTYPE;
mg tp_guardarmedicion%ROWTYPE;
BEGIN
--PRIMER PASO, HALLAR EL PASO MAS ALTO DE LAS TRES TABLAS
EXECUTE FORMAT('SELECT ultimo_paso($1)') INTO num_paso USING _nombretabla;
RAISE NOTICE 'ULTIMO PASO: %',num_paso;
--AHORA VOY RESTAURANDO ELEMENTOS DE CADA TABLA. SIEMPRE COMPRUEBO PRIMERO SI EXISTEN.
--TABLA RELACION
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = $1)') INTO existe USING tablaguardarrelacion;
IF existe IS TRUE THEN
    FOR rg IN EXECUTE FORMAT ('SELECT * FROM %I WHERE paso = $1',tablaguardarrelacion) USING num_paso
	LOOP
	    r=rg.r;
	    /*EXECUTE FORMAT ('INSERT INTO %I VALUES(%s,%L,%L,%s,%s,%s)',tablarelacion,
	    r.id, r.codpadre, r.codhijo, r.canpres,r.cancert,r.posicion);*/
	    PERFORM insertar_tipo_relacion(_nombretabla,r);
	END LOOP;
    EXECUTE FORMAT ('DELETE FROM %I WHERE paso = %s',tablaguardarrelacion,num_paso);
END IF;
--TABLA CONCEPTOS
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = $1)') INTO existe USING tablaguardarconceptos;
IF existe IS TRUE THEN
    FOR cg IN EXECUTE FORMAT ('SELECT * FROM %I WHERE paso = $1',tablaguardarconceptos) USING num_paso
	LOOP
	    c=cg.c;	
	    PERFORM insertar_tipo_concepto(_nombretabla,c);
	    PERFORM actualizar_desde_nodo(_nombretabla,c.codigo);
	END LOOP;
    EXECUTE FORMAT ('DELETE FROM %I WHERE paso = %s',tablaguardarconceptos,num_paso);
END IF;
--TABLA MEDICIONES
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = $1)') INTO existe USING tablaguardarmedicion; 
IF existe IS TRUE THEN
    FOR mg IN EXECUTE FORMAT ('SELECT * FROM %I WHERE paso = $1',tablaguardarmedicion) USING num_paso
	LOOP
	m=mg.m;
	PERFORM insertar_tipo_medcert(_nombretabla,m,m.num_certif);
	END LOOP;
	--PERFORM actualizar_desde_nodo(_nombretabla,m.codpadre);
	PERFORM modificar_cantidad(_nombretabla,m.codpadre,m.codhijo,m.num_certif);
    EXECUTE FORMAT ('DELETE FROM %I WHERE paso = %s',tablaguardarmedicion,num_paso);
END IF;
END;
$_$;


ALTER FUNCTION public.restaurar_lineas_borradas(_nombretabla character varying, _tipotabla integer) OWNER TO postgres;

--
-- TOC entry 259 (class 1255 OID 117892)
-- Name: ultimo_paso(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ultimo_paso(_nombretabla character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
tablaguardarconceptos character varying := _nombretabla || '_GuardarConceptos';
tablaguardarrelacion character varying := _nombretabla || '_GuardarRelaciones';
tablaguardarmedicion character varying := _nombretabla || '_GuardarMediciones';

ultimo_paso_conceptos integer :=0;
ultimo_paso_relacion integer :=0;
ultimo_paso_mediciones integer :=0;
ultimo_paso integer :=0;
num_registros integer :=0;
existe boolean;
BEGIN
--maximo paso tabla conceptos
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = $1)') INTO existe USING tablaguardarconceptos;
IF existe IS TRUE THEN
	EXECUTE FORMAT ('SELECT COUNT(*) FROM %I',tablaguardarconceptos) INTO num_registros;
	IF num_registros>0 THEN
		EXECUTE FORMAT ('SELECT MAX(paso) FROM %I',tablaguardarconceptos) INTO ultimo_paso_conceptos;	
	END IF;
END IF;
--maximo paso tabla relacion
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = $1)') INTO existe USING tablaguardarrelacion;
IF existe IS TRUE THEN
	EXECUTE FORMAT ('SELECT COUNT(*) FROM %I',tablaguardarrelacion) INTO num_registros;
	IF num_registros>0 THEN
		EXECUTE FORMAT ('SELECT MAX(paso) FROM %I',tablaguardarrelacion) INTO ultimo_paso_relacion;
	END IF;
END IF;
--maximo paso tabla medicion
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = $1)') INTO existe USING tablaguardarmedicion;
IF existe IS TRUE THEN
	EXECUTE FORMAT ('SELECT COUNT(*) FROM %I',tablaguardarmedicion) INTO num_registros;
	IF num_registros>0 THEN		
		EXECUTE FORMAT ('SELECT MAX(paso) FROM %I',tablaguardarmedicion) INTO ultimo_paso_mediciones;
	END IF;
END IF;

CREATE TEMP TABLE IF NOT EXISTS temp_maximos (paso integer);
INSERT INTO temp_maximos VALUES(ultimo_paso_conceptos);   
INSERT INTO temp_maximos VALUES(ultimo_paso_relacion);
INSERT INTO temp_maximos VALUES(ultimo_paso_mediciones);
ultimo_paso = (SELECT MAX(paso) FROM temp_maximos);
IF ultimo_paso IS NULL THEN ultimo_paso =0;END IF;
DROP TABLE temp_maximos;
RETURN ultimo_paso;
END;
$_$;


ALTER FUNCTION public.ultimo_paso(_nombretabla character varying) OWNER TO postgres;

--
-- TOC entry 274 (class 1255 OID 68823)
-- Name: ver_anterior(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ver_anterior(nombretabla character varying, codpadre character varying, codhijo character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
tablarelacion character varying := nombretabla||'_Relacion';
str_null_case character varying;
codigo_anterior character varying;
BEGIN
IF (codpadre = '') IS NOT FALSE THEN
	str_null_case := 'codpadre IS NULL';
ELSE
	str_null_case := 'codpadre = '||quote_literal(codpadre);
END IF;
EXECUTE FORMAT ('SELECT codhijo FROM %I WHERE %s AND posicion = (SELECT posicion FROM %I WHERE %s AND codhijo = %L)- 1',
tablarelacion,str_null_case,tablarelacion,str_null_case,codhijo) INTO codigo_anterior;
IF codigo_anterior = '' IS NOT FALSE THEN codigo_anterior = codhijo; END IF;
RETURN codigo_anterior;
END;
$$;


ALTER FUNCTION public.ver_anterior(nombretabla character varying, codpadre character varying, codhijo character varying) OWNER TO postgres;

--
-- TOC entry 286 (class 1255 OID 119411)
-- Name: ver_certificacion_actual(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ver_certificacion_actual(_nombretabla character varying, OUT _num_cert integer, OUT _fecha character varying) RETURNS record
    LANGUAGE plpgsql
    AS $$
DECLARE
tabla_listado_certificaciones character varying := _nombretabla || '_ListadoCertificaciones';
indice integer := 1;
var_r record;
existe boolean;
BEGIN
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %L)', tabla_listado_certificaciones) INTO existe;
IF existe IS FALSE THEN
	_num_cert = 0;
	_fecha = '';
ELSE
FOR var_r IN EXECUTE FORMAT ('SELECT ROW_NUMBER () OVER (ORDER BY fecha) AS num, fecha, actual FROM %I',tabla_listado_certificaciones)
	LOOP
	    IF var_r.actual IS TRUE THEN
		_num_cert = indice;
		_fecha = to_char(var_r.fecha,'DDMMYYYY');
	    END IF;
	    indice = indice + 1;
	END LOOP;
END IF;
END;
$$;


ALTER FUNCTION public.ver_certificacion_actual(_nombretabla character varying, OUT _num_cert integer, OUT _fecha character varying) OWNER TO postgres;

--
-- TOC entry 282 (class 1255 OID 119409)
-- Name: ver_certificaciones(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ver_certificaciones(_nombretabla character varying) RETURNS TABLE(num_cert integer, fecha character varying, actual boolean)
    LANGUAGE plpgsql
    AS $$
DECLARE
tablalistadocertificaciones character varying := _nombretabla || '_ListadoCertificaciones';
var_r record;
indice integer:=1;
BEGIN
FOR var_r IN EXECUTE FORMAT ('SELECT fecha, actual FROM %I ORDER BY fecha',tablalistadocertificaciones) LOOP
	num_cert = indice;
	fecha = to_char(var_r.fecha,'DDMMYYYY');
	actual = var_r.actual;
	RETURN NEXT;
	indice = indice +1;

END LOOP;
END;
$$;


ALTER FUNCTION public.ver_certificaciones(_nombretabla character varying) OWNER TO postgres;

--
-- TOC entry 310 (class 1255 OID 43474)
-- Name: ver_color_hijos(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ver_color_hijos(nombretabla character varying, codigopadre character varying, codigohijo character varying) RETURNS TABLE(codigo integer, naturaleza integer, ud integer, resumen integer, canpres integer, cancert integer, portcertpres integer, preciomed integer, preciocert integer, imppres integer, impcert integer)
    LANGUAGE plpgsql
    AS $$
DECLARE 
    var_r record;
    tabla_conceptos character varying;
    tabla_relacion character varying;
    str_null_case character varying;
BEGIN
tabla_conceptos := quote_ident(CONCAT(nombretabla,'_Conceptos'));
tabla_relacion := quote_ident(CONCAT(nombretabla,'_Relacion'));
IF (codigopadre = '') IS NOT FALSE THEN
	str_null_case := 'R.codpadre IS NULL';
ELSE
	str_null_case := 'R.codpadre = '||quote_literal(codigopadre);
END IF;
--nodo padre	
 FOR var_r IN EXECUTE 'SELECT ' || 
        'C.codigo,'||
	'C.naturaleza,'||
	'C.ud,'||
	'C.resumen,'||
	'R.canpres,'|| 
	'R.cancert,'||
	'R.cancert / NULLIF(R.canpres,0) AS portcertpres,'||
	'C.preciomed,'||
	'C.preciocert,'||
	'R.canpres * C.preciomed as imppres,'||
	'R.cancert * C.preciocert as impcert
 FROM '||tabla_conceptos||'AS C,'||tabla_relacion||
 ' AS R WHERE C.codigo = '|| quote_literal(codigohijo) ||
 ' AND '||str_null_case||
 ' AND R.codhijo = C.codigo'
 LOOP
        codigo := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        naturaleza := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        ud := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        resumen := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        canpres := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        cancert := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        portcertpres := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        preciomed := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        preciocert := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        imppres := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        impcert := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        RETURN NEXT;
 END LOOP;
 --nodos hijos
 FOR var_r IN EXECUTE 'SELECT '||
	'C.codigo,'||
	'C.naturaleza,'||
	'C.ud,'||
	'C.resumen,'||
	'R.canpres,'||
	'R.cancert,'||
	'R.cancert/NULLIF(R.canpres,0) AS portcertpres,'||
	'C.preciomed,'||
	'C.preciocert,'||
	'R.canpres * C.preciomed as imppres,'||
	'R.cancert * C.preciocert as impcert
 FROM '||tabla_conceptos||'AS C,'||tabla_relacion ||
 ' AS R WHERE R.codpadre = '||quote_literal(codigohijo)||
 ' AND C.codigo = R.codhijo ORDER BY R.posicion'
 LOOP        
        codigo := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        naturaleza := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        ud := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        resumen := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        canpres := CASE WHEN (hay_medicion(nombretabla, codigohijo, var_r.codigo)) IS TRUE THEN
			array_length(enum_range(NULL, 'DESCOMPUESTO'::color), 1)
		ELSE 
			array_length(enum_range(NULL, 'NORMAL'::color), 1)
		END;
        cancert := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        portcertpres := array_length(enum_range(NULL, 'DESCOMPUESTO'::color), 1);
        preciomed := CASE WHEN (es_precio_bloqueado(nombretabla, var_r.codigo)) IS TRUE THEN 
			array_length(enum_range(NULL, 'BLOQUEADO'::color), 1)
		     --ELSE 
			WHEN (hay_descomposicion(nombretabla, var_r.codigo)) IS TRUE THEN 
			array_length(enum_range(NULL, 'DESCOMPUESTO'::color), 1)
		     ELSE
			array_length(enum_range(NULL, 'NORMAL'::color), 1)
		     END;
        preciocert := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        imppres := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        impcert := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        RETURN NEXT;
 END LOOP;
 END; $$;


ALTER FUNCTION public.ver_color_hijos(nombretabla character varying, codigopadre character varying, codigohijo character varying) OWNER TO postgres;

--
-- TOC entry 320 (class 1255 OID 43467)
-- Name: ver_hijos(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ver_hijos(nombretabla character varying, codigopadre character varying, codigohijo character varying) RETURNS TABLE(codigo character varying, naturaleza integer, ud character varying, resumen character varying, canpres numeric, cancert numeric, portcertpres numeric, preciomed numeric, preciocert numeric, imppres numeric, impcert numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE 
    var_r record;
    tabla_conceptos character varying;
    tabla_relacion character varying;
    str_null_case character varying;
BEGIN
tabla_conceptos := quote_ident(CONCAT(nombretabla,'_Conceptos'));
tabla_relacion := quote_ident(CONCAT(nombretabla,'_Relacion'));
IF (codigopadre = '') IS NOT FALSE THEN
	str_null_case := 'R.codpadre IS NULL';
ELSE
	str_null_case := 'R.codpadre = '||quote_literal(codigopadre);
END IF;
--nodo padre	
 FOR var_r IN EXECUTE 'SELECT ' || 
        'C.codigo,'||
	'C.naturaleza,'||
	'C.ud,'||
	'C.resumen,'||
	'R.canpres,'|| 
	'R.cancert,'||
	'R.cancert / NULLIF(R.canpres,0) AS portcertpres,'||
	'C.preciomed,'||
	'C.preciocert,'||
	'R.canpres * C.preciomed as imppres,'||
	'R.cancert * C.preciocert as impcert
 FROM '||tabla_conceptos||'AS C,'||tabla_relacion||
 ' AS R WHERE C.codigo = '|| quote_literal(codigohijo) ||
 ' AND '||str_null_case||
 ' AND R.codhijo = C.codigo'
 LOOP
        codigo := var_r.codigo;
        naturaleza := var_r.naturaleza;
        ud := var_r.ud;
        resumen := var_r.resumen;
        canpres := var_r.canpres;
        cancert := var_r.cancert;
        portcertpres := var_r.portcertpres;
        preciomed := var_r.preciomed;
        preciocert := var_r.preciocert;
        imppres := var_r.imppres;
        impcert := var_r.impcert;
        RETURN NEXT;
 END LOOP;
 --nodos hijos
 FOR var_r IN EXECUTE 'SELECT '||
	'C.codigo,'||
	'C.naturaleza,'||
	'C.ud,'||
	'C.resumen,'||
	'R.canpres,'||
	'R.cancert,'||
	'R.cancert/NULLIF(R.canpres,0) AS portcertpres,'||
	'C.preciomed,'||
	'C.preciocert,'||
	'R.canpres * C.preciomed as imppres,'||
	'R.cancert * C.preciocert as impcert
 FROM '||tabla_conceptos||'AS C,'||tabla_relacion ||
 ' AS R WHERE R.codpadre = '||quote_literal(codigohijo)||
 ' AND C.codigo = R.codhijo ORDER BY R.posicion'
 LOOP
        codigo := var_r.codigo;
        naturaleza := var_r.naturaleza;
        ud := var_r.ud;
        resumen := var_r.resumen;
        canpres := var_r.canpres;
        cancert := var_r.cancert;
        portcertpres := var_r.portcertpres;
        preciomed := var_r.preciomed;
        preciocert := var_r.preciocert;
        imppres := var_r.imppres;
        impcert := var_r.impcert;
        RETURN NEXT;
 END LOOP;
 END; $$;


ALTER FUNCTION public.ver_hijos(nombretabla character varying, codigopadre character varying, codigohijo character varying) OWNER TO postgres;

--
-- TOC entry 284 (class 1255 OID 119393)
-- Name: ver_lineas_medcert(character varying, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ver_lineas_medcert(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _tipocantidad integer) RETURNS TABLE(tipo integer, comentario character varying, ud numeric, longitud numeric, anchura numeric, altura numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
idpadre integer;
idhijo integer;
var_r record;
tablamediciones character varying := _nombretabla || '_Mediciones';
tablaconceptos character varying := _nombretabla || '_Conceptos';
numcert character varying;
str_null_case character varying;
BEGIN
--construimos la cadena del padre
IF _codigopadre = '' IS NOT FALSE THEN
	str_null_case := quote_ident(tablamediciones)||'.codpadre IS NULL';
ELSE
	str_null_case := quote_ident(tablamediciones)||'.codpadre = '||quote_literal(_codigopadre);
END IF;
--la cadena de numcert
IF _tipocantidad = 0 THEN
    numcert = '= 0';
ELSE
    numcert = '>0';
END IF;
--RAISE NOTICE 'lOS DATOS SON: %, %',idpadre,idhijo;

FOR var_r IN EXECUTE 'SELECT ' || 
        quote_ident(tablamediciones) ||'.tipo,'||
	quote_ident(tablamediciones) ||'.comentario,'||
	quote_ident(tablamediciones) ||'.ud,'||
	quote_ident(tablamediciones) ||'.longitud,'||
	quote_ident(tablamediciones) ||'.anchura,'|| 
	quote_ident(tablamediciones) ||'.altura'||
 ' FROM '||quote_ident(tablamediciones)||
 ' WHERE '||quote_ident(tablamediciones)||'.codhijo = '||quote_literal(_codigohijo)||
 ' AND '||str_null_case||' AND num_certif '||numcert||
 ' ORDER BY '||quote_ident(tablamediciones)||'.id'
 LOOP
        tipo := var_r.tipo;
        comentario := var_r.comentario;
        ud := var_r.ud;
        longitud := var_r.longitud;
        anchura := var_r.anchura;
        altura := var_r.altura;         
        RETURN NEXT;
END LOOP;
END;
$$;


ALTER FUNCTION public.ver_lineas_medcert(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _tipocantidad integer) OWNER TO postgres;

--
-- TOC entry 305 (class 1255 OID 114520)
-- Name: ver_lineas_medicion(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ver_lineas_medicion(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying) RETURNS TABLE(tipo integer, comentario character varying, ud numeric, longitud numeric, anchura numeric, altura numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
idpadre integer;
idhijo integer;
var_r record;
tablamediciones character varying := _nombretabla || '_Mediciones';
tablaconceptos character varying := _nombretabla || '_Conceptos';
str_null_case character varying;
BEGIN
--construimos la cadena del padre
IF _codigopadre = '' IS NOT FALSE THEN
	str_null_case := quote_ident(tablamediciones)||'.codpadre IS NULL';
ELSE
	str_null_case := quote_ident(tablamediciones)||'.codpadre = '||quote_literal(_codigopadre);
END IF;
--RAISE NOTICE 'lOS DATOS SON: %, %',idpadre,idhijo;

FOR var_r IN EXECUTE 'SELECT ' || 
        quote_ident(tablamediciones) ||'.tipo,'||
	quote_ident(tablamediciones) ||'.comentario,'||
	quote_ident(tablamediciones) ||'.ud,'||
	quote_ident(tablamediciones) ||'.longitud,'||
	quote_ident(tablamediciones) ||'.anchura,'|| 
	quote_ident(tablamediciones) ||'.altura'||
 ' FROM '||quote_ident(tablamediciones)||
 ' WHERE '||quote_ident(tablamediciones)||'.codhijo = '||quote_literal(_codigohijo)||
 ' AND '||str_null_case||
 ' ORDER BY '||quote_ident(tablamediciones)||'.id'
 LOOP
        tipo := var_r.tipo;
        comentario := var_r.comentario;
        ud := var_r.ud;
        longitud := var_r.longitud;
        anchura := var_r.anchura;
        altura := var_r.altura;         
        RETURN NEXT;
END LOOP;
END;
$$;


ALTER FUNCTION public.ver_lineas_medicion(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying) OWNER TO postgres;

--
-- TOC entry 277 (class 1255 OID 119161)
-- Name: ver_medcert(character varying, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ver_medcert(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _num_certif integer DEFAULT 0) RETURNS TABLE(fase integer, comentario character varying, ud numeric, longitud numeric, anchura numeric, altura numeric, formula character varying, parcial numeric, subtotal numeric, tipo integer, id integer, pos integer)
    LANGUAGE plpgsql
    AS $_$
DECLARE 
    var_r record;
    tablamedcert character varying := _nombretabla||'_Mediciones';
    str_null_case character varying;
    acum numeric(7,3) := 0;    
    subt_parc numeric(7,3) := 0;
BEGIN
acum = 0;
IF (_codigopadre = '') IS NOT FALSE THEN
	str_null_case := 'codpadre IS NULL';
ELSE
	str_null_case := 'codpadre = '||quote_literal(_codigopadre);
END IF;
FOR var_r IN EXECUTE FORMAT('SELECT * FROM %I WHERE codhijo = $1 AND %s AND num_certif = $2 ORDER BY posicion',tablamedcert,str_null_case) USING _codigohijo,_num_certif
 LOOP
        fase := var_r.num_certif;
        comentario := var_r.comentario;
        ud := var_r.ud;
        longitud := var_r.longitud;
        anchura := var_r.anchura;
        altura := var_r.altura;
        formula := var_r.formula;        
        parcial := procesar_linea_medicion(var_r.ud, var_r.longitud, var_r.anchura, var_r.altura, var_r.formula);
        --RAISE NOTICE 'El parcial es: %',parcial;
        acum = acum+parcial;
        IF var_r.tipo =1 THEN		
		subtotal = acum - subt_parc;
		subt_parc = acum;
	ELSIF var_r.tipo =2 THEN
		subtotal = acum;
		acum = acum - parcial;
	ELSE
		subtotal = 0;
	END IF;
	tipo := var_r.tipo;
        id :=var_r.id;
        pos := var_r.posicion;	
        RETURN NEXT;
 END LOOP;
 END; $_$;


ALTER FUNCTION public.ver_medcert(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _num_certif integer) OWNER TO postgres;

--
-- TOC entry 293 (class 1255 OID 119781)
-- Name: ver_obra(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ver_obra(_nombretabla character varying) RETURNS TABLE(codigo character varying, naturaleza integer, ud character varying, resumen character varying, canpres numeric, cancert numeric, portcertpres numeric, preciomed numeric, preciocert numeric, imppres numeric, impcert numeric)
    LANGUAGE plpgsql
    AS $_$
DECLARE
tablaconceptos character varying := _nombretabla || '_Conceptos';
tablarelacion character varying := _nombretabla || '_Relacion';
punto char :='.';
R record;

BEGIN
EXECUTE FORMAT (' WITH RECURSIVE tree AS(SELECT codpadre, codhijo, canpres, 1 AS depth, cast(posicion as text) as camino,posicion from %I
WHERE codpadre is NULL
UNION ALL
SELECT rel.codpadre, rel.codhijo, rel.canpres, depth+1, camino ||$1|| cast(rel.posicion as text) , rel.posicion
FROM %I rel
JOIN tree t ON rel.codpadre = t.codhijo
)
SELECT C.codigo, C.naturaleza, C.ud, C.resumen,tree.canpres,tree.cancert, C.preciocert/C.preciomed AS "Porcerntaje", C.preciomed, C.preciocert, C.preciomed*tree.canpres as "Importe presupuesto", C.preciocert*tree.cancert as "Importe certifi.", tree.depth 
FROM tree, %I AS C 
WHERE C.codigo=tree.codhijo
ORDER BY camino',tablarelacion,tablarelacion,tablaconceptos) USING punto;
RETURN NEXT;
END; $_$;


ALTER FUNCTION public.ver_obra(_nombretabla character varying) OWNER TO postgres;

--
-- TOC entry 298 (class 1255 OID 122197)
-- Name: ver_precio(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ver_precio(nombretabla character varying, cod character varying DEFAULT NULL::character varying) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaconceptos character varying := nombretabla||'_Conceptos';
precio_partida numeric;
BEGIN
IF cod IS NULL or cod = '' THEN
	cod = nombretabla;
END IF;
EXECUTE FORMAT ('SELECT preciomed FROM %I WHERE codigo = %L',tablaconceptos,cod) INTO precio_partida;
return precio_partida;
END;
$$;


ALTER FUNCTION public.ver_precio(nombretabla character varying, cod character varying) OWNER TO postgres;

--
-- TOC entry 275 (class 1255 OID 68822)
-- Name: ver_siguiente(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ver_siguiente(nombretabla character varying, codpadre character varying, codhijo character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
tablarelacion character varying := nombretabla||'_Relacion';
str_null_case character varying;
cod_siguiente character varying;
BEGIN
IF (codpadre = '') IS NOT FALSE THEN
	str_null_case := 'codpadre IS NULL';
ELSE
	str_null_case := 'codpadre = '||quote_literal(codpadre);
END IF;
EXECUTE FORMAT ('SELECT codhijo FROM %I WHERE %s AND posicion = (SELECT posicion FROM %I WHERE %s AND codhijo = %L)+ 1',
tablarelacion,str_null_case,tablarelacion,str_null_case,codhijo) INTO cod_siguiente;
IF cod_siguiente = '' IS NOT FALSE THEN cod_siguiente = codhijo; END IF;
return cod_siguiente;
END;
$$;


ALTER FUNCTION public.ver_siguiente(nombretabla character varying, codpadre character varying, codhijo character varying) OWNER TO postgres;

--
-- TOC entry 312 (class 1255 OID 27225)
-- Name: ver_texto(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ver_texto(nombretabla character varying, cod character varying) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaconceptos character varying := nombretabla||'_Conceptos';
texto_partida text;
BEGIN
EXECUTE FORMAT ('SELECT descripcionhtml FROM %I WHERE codigo = %L',tablaconceptos,cod) INTO texto_partida;
return texto_partida;
END;
$$;


ALTER FUNCTION public.ver_texto(nombretabla character varying, cod character varying) OWNER TO postgres;

--
-- TOC entry 290 (class 1255 OID 119432)
-- Name: ver_todas_certificaciones(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ver_todas_certificaciones(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying) RETURNS TABLE(fase integer, comentario character varying, ud numeric, longitud numeric, anchura numeric, altura numeric, formula character varying, parcial numeric, subtotal numeric, tipo integer, id integer, pos integer)
    LANGUAGE plpgsql
    AS $_$
DECLARE 
    var_r record;
    tablamedcert character varying := _nombretabla||'_Mediciones';
    str_null_case character varying;
    acum numeric(7,3) := 0;    
    subt_parc numeric(7,3) := 0;
BEGIN
acum = 0;
IF (_codigopadre = '') IS NOT FALSE THEN
	str_null_case := 'codpadre IS NULL';
ELSE
	str_null_case := 'codpadre = '||quote_literal(_codigopadre);
END IF;
FOR var_r IN EXECUTE FORMAT('SELECT * FROM %I WHERE codhijo = $1 AND %s AND num_certif > 0 ORDER BY posicion',tablamedcert,str_null_case) USING _codigohijo
 LOOP
        fase := var_r.num_certif;
        comentario := var_r.comentario;
        ud := var_r.ud;
        longitud := var_r.longitud;
        anchura := var_r.anchura;
        altura := var_r.altura;
        formula := var_r.formula;        
        parcial := procesar_linea_medicion(var_r.ud, var_r.longitud, var_r.anchura, var_r.altura, var_r.formula);
        --RAISE NOTICE 'El parcial es: %',parcial;
        acum = acum+parcial;
        IF var_r.tipo =1 THEN		
		subtotal = acum - subt_parc;
		subt_parc = acum;
	ELSIF var_r.tipo =2 THEN
		subtotal = acum;
		acum = acum - parcial;
	ELSE
		subtotal = 0;
	END IF;
	tipo := var_r.tipo;
        id :=var_r.id;
        pos := var_r.posicion;	
        RETURN NEXT;
 END LOOP;
 END; $_$;


ALTER FUNCTION public.ver_todas_certificaciones(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 212 (class 1259 OID 116316)
-- Name: CENZANO_Conceptos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."CENZANO_Conceptos" OF public.tp_concepto (
    codigo WITH OPTIONS NOT NULL
);


ALTER TABLE public."CENZANO_Conceptos" OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 116343)
-- Name: CENZANO_Mediciones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."CENZANO_Mediciones_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."CENZANO_Mediciones_id_seq" OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 116335)
-- Name: CENZANO_Mediciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."CENZANO_Mediciones" OF public.tp_medicion (
    id WITH OPTIONS DEFAULT nextval('public."CENZANO_Mediciones_id_seq"'::regclass) NOT NULL
);


ALTER TABLE public."CENZANO_Mediciones" OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 116332)
-- Name: CENZANO_Relacion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."CENZANO_Relacion_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."CENZANO_Relacion_id_seq" OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 116324)
-- Name: CENZANO_Relacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."CENZANO_Relacion" OF public.tp_relacion (
    id WITH OPTIONS DEFAULT nextval('public."CENZANO_Relacion_id_seq"'::regclass) NOT NULL
);


ALTER TABLE public."CENZANO_Relacion" OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 119561)
-- Name: O2017001_Conceptos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."O2017001_Conceptos" OF public.tp_concepto (
    codigo WITH OPTIONS NOT NULL
);


ALTER TABLE public."O2017001_Conceptos" OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 119588)
-- Name: O2017001_Mediciones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."O2017001_Mediciones_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."O2017001_Mediciones_id_seq" OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 119580)
-- Name: O2017001_Mediciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."O2017001_Mediciones" OF public.tp_medicion (
    id WITH OPTIONS DEFAULT nextval('public."O2017001_Mediciones_id_seq"'::regclass) NOT NULL
);


ALTER TABLE public."O2017001_Mediciones" OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 119577)
-- Name: O2017001_Relacion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."O2017001_Relacion_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."O2017001_Relacion_id_seq" OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 119569)
-- Name: O2017001_Relacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."O2017001_Relacion" OF public.tp_relacion (
    id WITH OPTIONS DEFAULT nextval('public."O2017001_Relacion_id_seq"'::regclass) NOT NULL
);


ALTER TABLE public."O2017001_Relacion" OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 117841)
-- Name: PRUEBASCOMP_Certificaciones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."PRUEBASCOMP_Certificaciones_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."PRUEBASCOMP_Certificaciones_id_seq" OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 121471)
-- Name: PRUEBASCOMP_Conceptos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PRUEBASCOMP_Conceptos" OF public.tp_concepto (
    codigo WITH OPTIONS NOT NULL
);


ALTER TABLE public."PRUEBASCOMP_Conceptos" OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 139705)
-- Name: PRUEBASCOMP_GuardarConceptos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PRUEBASCOMP_GuardarConceptos" OF public.tp_guardarconcepto (
    idguardar WITH OPTIONS NOT NULL
);


ALTER TABLE public."PRUEBASCOMP_GuardarConceptos" OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 139650)
-- Name: PRUEBASCOMP_GuardarMediciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PRUEBASCOMP_GuardarMediciones" OF public.tp_guardarmedicion (
    idguardar WITH OPTIONS NOT NULL
);


ALTER TABLE public."PRUEBASCOMP_GuardarMediciones" OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 139697)
-- Name: PRUEBASCOMP_GuardarRelaciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PRUEBASCOMP_GuardarRelaciones" OF public.tp_guardarrelacion (
    idguardar WITH OPTIONS NOT NULL
);


ALTER TABLE public."PRUEBASCOMP_GuardarRelaciones" OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 121501)
-- Name: PRUEBASCOMP_ListadoCertificaciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PRUEBASCOMP_ListadoCertificaciones" OF public.tp_certificacion (
    fecha WITH OPTIONS NOT NULL
);


ALTER TABLE public."PRUEBASCOMP_ListadoCertificaciones" OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 121498)
-- Name: PRUEBASCOMP_Mediciones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."PRUEBASCOMP_Mediciones_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."PRUEBASCOMP_Mediciones_id_seq" OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 121490)
-- Name: PRUEBASCOMP_Mediciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PRUEBASCOMP_Mediciones" OF public.tp_medicion (
    id WITH OPTIONS DEFAULT nextval('public."PRUEBASCOMP_Mediciones_id_seq"'::regclass) NOT NULL
);


ALTER TABLE public."PRUEBASCOMP_Mediciones" OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 121487)
-- Name: PRUEBASCOMP_Relacion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."PRUEBASCOMP_Relacion_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."PRUEBASCOMP_Relacion_id_seq" OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 121479)
-- Name: PRUEBASCOMP_Relacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PRUEBASCOMP_Relacion" OF public.tp_relacion (
    id WITH OPTIONS DEFAULT nextval('public."PRUEBASCOMP_Relacion_id_seq"'::regclass) NOT NULL
);


ALTER TABLE public."PRUEBASCOMP_Relacion" OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 120067)
-- Name: VANDALISMO_Conceptos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."VANDALISMO_Conceptos" OF public.tp_concepto (
    codigo WITH OPTIONS NOT NULL
);


ALTER TABLE public."VANDALISMO_Conceptos" OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 120094)
-- Name: VANDALISMO_Mediciones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."VANDALISMO_Mediciones_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."VANDALISMO_Mediciones_id_seq" OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 120086)
-- Name: VANDALISMO_Mediciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."VANDALISMO_Mediciones" OF public.tp_medicion (
    id WITH OPTIONS DEFAULT nextval('public."VANDALISMO_Mediciones_id_seq"'::regclass) NOT NULL
);


ALTER TABLE public."VANDALISMO_Mediciones" OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 120083)
-- Name: VANDALISMO_Relacion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."VANDALISMO_Relacion_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."VANDALISMO_Relacion_id_seq" OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 120075)
-- Name: VANDALISMO_Relacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."VANDALISMO_Relacion" OF public.tp_relacion (
    id WITH OPTIONS DEFAULT nextval('public."VANDALISMO_Relacion_id_seq"'::regclass) NOT NULL
);


ALTER TABLE public."VANDALISMO_Relacion" OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 118460)
-- Name: __CopiarConceptos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."__CopiarConceptos" OF public.tp_concepto (
    codigo WITH OPTIONS NOT NULL
);


ALTER TABLE public."__CopiarConceptos" OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 118468)
-- Name: __CopiarMediciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."__CopiarMediciones" OF public.tp_medicion (
    id WITH OPTIONS NOT NULL
);


ALTER TABLE public."__CopiarMediciones" OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 118452)
-- Name: __CopiarRelacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."__CopiarRelacion" OF public.tp_relacion (
    id WITH OPTIONS NOT NULL
);


ALTER TABLE public."__CopiarRelacion" OWNER TO postgres;

--
-- TOC entry 2323 (class 2606 OID 116323)
-- Name: CENZANO_Conceptos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CENZANO_Conceptos"
    ADD CONSTRAINT "CENZANO_Conceptos_pkey" PRIMARY KEY (codigo);


--
-- TOC entry 2327 (class 2606 OID 116342)
-- Name: CENZANO_Mediciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CENZANO_Mediciones"
    ADD CONSTRAINT "CENZANO_Mediciones_pkey" PRIMARY KEY (id);


--
-- TOC entry 2325 (class 2606 OID 116331)
-- Name: CENZANO_Relacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CENZANO_Relacion"
    ADD CONSTRAINT "CENZANO_Relacion_pkey" PRIMARY KEY (id);


--
-- TOC entry 2335 (class 2606 OID 119568)
-- Name: O2017001_Conceptos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."O2017001_Conceptos"
    ADD CONSTRAINT "O2017001_Conceptos_pkey" PRIMARY KEY (codigo);


--
-- TOC entry 2339 (class 2606 OID 119587)
-- Name: O2017001_Mediciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."O2017001_Mediciones"
    ADD CONSTRAINT "O2017001_Mediciones_pkey" PRIMARY KEY (id);


--
-- TOC entry 2337 (class 2606 OID 119576)
-- Name: O2017001_Relacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."O2017001_Relacion"
    ADD CONSTRAINT "O2017001_Relacion_pkey" PRIMARY KEY (id);


--
-- TOC entry 2347 (class 2606 OID 121478)
-- Name: PRUEBASCOMP_Conceptos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PRUEBASCOMP_Conceptos"
    ADD CONSTRAINT "PRUEBASCOMP_Conceptos_pkey" PRIMARY KEY (codigo);


--
-- TOC entry 2359 (class 2606 OID 139712)
-- Name: PRUEBASCOMP_GuardarConceptos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PRUEBASCOMP_GuardarConceptos"
    ADD CONSTRAINT "PRUEBASCOMP_GuardarConceptos_pkey" PRIMARY KEY (idguardar);


--
-- TOC entry 2355 (class 2606 OID 139657)
-- Name: PRUEBASCOMP_GuardarMediciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PRUEBASCOMP_GuardarMediciones"
    ADD CONSTRAINT "PRUEBASCOMP_GuardarMediciones_pkey" PRIMARY KEY (idguardar);


--
-- TOC entry 2357 (class 2606 OID 139704)
-- Name: PRUEBASCOMP_GuardarRelaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PRUEBASCOMP_GuardarRelaciones"
    ADD CONSTRAINT "PRUEBASCOMP_GuardarRelaciones_pkey" PRIMARY KEY (idguardar);


--
-- TOC entry 2353 (class 2606 OID 121505)
-- Name: PRUEBASCOMP_ListadoCertificaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PRUEBASCOMP_ListadoCertificaciones"
    ADD CONSTRAINT "PRUEBASCOMP_ListadoCertificaciones_pkey" PRIMARY KEY (fecha);


--
-- TOC entry 2351 (class 2606 OID 121497)
-- Name: PRUEBASCOMP_Mediciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PRUEBASCOMP_Mediciones"
    ADD CONSTRAINT "PRUEBASCOMP_Mediciones_pkey" PRIMARY KEY (id);


--
-- TOC entry 2349 (class 2606 OID 121486)
-- Name: PRUEBASCOMP_Relacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PRUEBASCOMP_Relacion"
    ADD CONSTRAINT "PRUEBASCOMP_Relacion_pkey" PRIMARY KEY (id);


--
-- TOC entry 2341 (class 2606 OID 120074)
-- Name: VANDALISMO_Conceptos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."VANDALISMO_Conceptos"
    ADD CONSTRAINT "VANDALISMO_Conceptos_pkey" PRIMARY KEY (codigo);


--
-- TOC entry 2345 (class 2606 OID 120093)
-- Name: VANDALISMO_Mediciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."VANDALISMO_Mediciones"
    ADD CONSTRAINT "VANDALISMO_Mediciones_pkey" PRIMARY KEY (id);


--
-- TOC entry 2343 (class 2606 OID 120082)
-- Name: VANDALISMO_Relacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."VANDALISMO_Relacion"
    ADD CONSTRAINT "VANDALISMO_Relacion_pkey" PRIMARY KEY (id);


--
-- TOC entry 2331 (class 2606 OID 118467)
-- Name: __CopiarConceptos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."__CopiarConceptos"
    ADD CONSTRAINT "__CopiarConceptos_pkey" PRIMARY KEY (codigo);


--
-- TOC entry 2333 (class 2606 OID 118475)
-- Name: __CopiarMediciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."__CopiarMediciones"
    ADD CONSTRAINT "__CopiarMediciones_pkey" PRIMARY KEY (id);


--
-- TOC entry 2329 (class 2606 OID 118459)
-- Name: __CopiarRelacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."__CopiarRelacion"
    ADD CONSTRAINT "__CopiarRelacion_pkey" PRIMARY KEY (id);


--
-- TOC entry 2481 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2019-05-13 19:57:54 CEST

--
-- PostgreSQL database dump complete
--

