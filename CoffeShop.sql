--
-- PostgreSQL database dump
--

\restrict ZaCgNWMafHir86RD7dRJedLexvxHOsLJFueVvLrIiHfhAn0yClU64IhbXn6dj8d

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

-- Started on 2025-11-12 20:38:01

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5028 (class 1262 OID 25024)
-- Name: CoffeShop; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "CoffeShop" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.utf8';


ALTER DATABASE "CoffeShop" OWNER TO postgres;

\unrestrict ZaCgNWMafHir86RD7dRJedLexvxHOsLJFueVvLrIiHfhAn0yClU64IhbXn6dj8d
\connect "CoffeShop"
\restrict ZaCgNWMafHir86RD7dRJedLexvxHOsLJFueVvLrIiHfhAn0yClU64IhbXn6dj8d

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 228 (class 1259 OID 25153)
-- Name: invoices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invoices (
    invoice_id integer NOT NULL,
    order_id character varying(20) NOT NULL,
    invoice_number character varying(50) NOT NULL,
    issue_date timestamp without time zone DEFAULT now(),
    total_amount numeric(12,2) NOT NULL,
    tax_amount numeric(12,2) DEFAULT 0,
    status character varying(50) NOT NULL,
    note text
);


ALTER TABLE public.invoices OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 25152)
-- Name: invoices_invoice_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.invoices_invoice_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.invoices_invoice_id_seq OWNER TO postgres;

--
-- TOC entry 5029 (class 0 OID 0)
-- Dependencies: 227
-- Name: invoices_invoice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.invoices_invoice_id_seq OWNED BY public.invoices.invoice_id;


--
-- TOC entry 223 (class 1259 OID 25100)
-- Name: order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_items (
    order_item_id integer NOT NULL,
    order_id character varying(20) NOT NULL,
    product_id character varying(10) NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    unit_price numeric(12,2) NOT NULL,
    subtotal numeric(12,2) NOT NULL,
    note text,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.order_items OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 25099)
-- Name: order_items_order_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_items_order_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_items_order_item_id_seq OWNER TO postgres;

--
-- TOC entry 5030 (class 0 OID 0)
-- Dependencies: 222
-- Name: order_items_order_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_items_order_item_id_seq OWNED BY public.order_items.order_item_id;


--
-- TOC entry 221 (class 1259 OID 25076)
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    order_id character varying(20) NOT NULL,
    user_id integer NOT NULL,
    order_type character varying(50),
    status character varying(50) DEFAULT 'Pending'::character varying NOT NULL,
    total_amount numeric(12,2) DEFAULT 0,
    discount_amount numeric(12,2) DEFAULT 0,
    pay_method character varying(50),
    note text,
    promotion_id character varying(10),
    expires_at timestamp with time zone,
    is_cart boolean DEFAULT false,
    shipping_address character varying(500),
    phone_contact character varying(20),
    payment_amount numeric(12,2),
    payment_status character varying(50),
    payment_date timestamp with time zone,
    transaction_code character varying(100),
    payment_reference character varying(100),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 25138)
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    payment_id integer NOT NULL,
    order_id character varying(20) NOT NULL,
    payment_method character varying(50) NOT NULL,
    amount numeric(12,2) NOT NULL,
    status character varying(50) NOT NULL,
    transaction_code character varying(100),
    payment_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    note text
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 25137)
-- Name: payments_payment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payments_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payments_payment_id_seq OWNER TO postgres;

--
-- TOC entry 5031 (class 0 OID 0)
-- Dependencies: 225
-- Name: payments_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payments_payment_id_seq OWNED BY public.payments.payment_id;


--
-- TOC entry 219 (class 1259 OID 25039)
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    product_id character varying(10) NOT NULL,
    name character varying(255) NOT NULL,
    category character varying(100) NOT NULL,
    description text,
    price numeric(12,2) NOT NULL,
    is_bestseller boolean DEFAULT false,
    status character varying(50) DEFAULT 'Activate'::character varying NOT NULL,
    image_url character varying(500),
    stock_quantity integer DEFAULT 0,
    note text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.products OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 25170)
-- Name: promotion_products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_products (
    promotion_id character varying(10) NOT NULL,
    product_id character varying(10) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.promotion_products OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 25052)
-- Name: promotions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotions (
    promotion_id character varying(10) NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(50) NOT NULL,
    value numeric(12,2),
    min_order_value numeric(12,2),
    start_date date,
    end_date date,
    status character varying(50) DEFAULT 'Activate'::character varying NOT NULL,
    apply_to_all boolean DEFAULT true,
    max_uses integer,
    uses_count integer DEFAULT 0,
    description text,
    note text,
    promotion_scope character varying(20),
    created_by integer,
    updated_by integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.promotions OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 25120)
-- Name: settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.settings (
    setting_id character varying(10) NOT NULL,
    name character varying(100) NOT NULL,
    value text,
    datatype character varying(50),
    category character varying(100),
    status character varying(50) DEFAULT 'Active'::character varying NOT NULL,
    description text,
    note text,
    updated_by integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.settings OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 25026)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(500) NOT NULL,
    full_name character varying(255) NOT NULL,
    role character varying(50) NOT NULL,
    status character varying(50) DEFAULT 'Active'::character varying NOT NULL,
    reset_token character varying(500),
    note text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 25025)
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_user_id_seq OWNER TO postgres;

--
-- TOC entry 5032 (class 0 OID 0)
-- Dependencies: 217
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- TOC entry 4805 (class 2604 OID 25156)
-- Name: invoices invoice_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices ALTER COLUMN invoice_id SET DEFAULT nextval('public.invoices_invoice_id_seq'::regclass);


--
-- TOC entry 4797 (class 2604 OID 25103)
-- Name: order_items order_item_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items ALTER COLUMN order_item_id SET DEFAULT nextval('public.order_items_order_item_id_seq'::regclass);


--
-- TOC entry 4803 (class 2604 OID 25141)
-- Name: payments payment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments ALTER COLUMN payment_id SET DEFAULT nextval('public.payments_payment_id_seq'::regclass);


--
-- TOC entry 4777 (class 2604 OID 25029)
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- TOC entry 5021 (class 0 OID 25153)
-- Dependencies: 228
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5016 (class 0 OID 25100)
-- Dependencies: 223
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.order_items VALUES (142, 'ORD039', 'P005', 10, 49000.00, 490000.00, NULL, '2025-11-12 06:20:37.559003');
INSERT INTO public.order_items VALUES (143, 'ORD042', 'P006', 2, 55000.00, 110000.00, NULL, '2025-11-12 06:30:28.935012');
INSERT INTO public.order_items VALUES (144, 'ORD042', 'P005', 1, 49000.00, 49000.00, NULL, '2025-11-12 06:30:32.229915');
INSERT INTO public.order_items VALUES (154, 'ORD052', 'P002', 1, 30000.00, 30000.00, NULL, '2025-11-12 14:37:26.744329');
INSERT INTO public.order_items VALUES (155, 'ORD053', 'P005', 1, 49000.00, 49000.00, NULL, '2025-11-12 14:43:15.790063');
INSERT INTO public.order_items VALUES (156, 'ORD054', 'P002', 1, 30000.00, 30000.00, NULL, '2025-11-12 14:48:53.747605');
INSERT INTO public.order_items VALUES (146, 'ORD043', 'P005', 1, 49000.00, 49000.00, NULL, '2025-11-12 08:03:42.082302');
INSERT INTO public.order_items VALUES (147, 'ORD044', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-12 08:07:15.190368');
INSERT INTO public.order_items VALUES (148, 'ORD044', 'P005', 1, 49000.00, 49000.00, NULL, '2025-11-12 08:07:16.727784');
INSERT INTO public.order_items VALUES (149, 'ORD046', 'P006', 2, 55000.00, 110000.00, NULL, '2025-11-12 09:10:36.610736');
INSERT INTO public.order_items VALUES (150, 'ORD049', 'P002', 1, 30000.00, 30000.00, NULL, '2025-11-12 13:50:17.688223');
INSERT INTO public.order_items VALUES (151, 'ORD050', 'P005', 1, 49000.00, 49000.00, NULL, '2025-11-12 13:53:18.145416');
INSERT INTO public.order_items VALUES (152, 'ORD051', 'P002', 1, 30000.00, 30000.00, NULL, '2025-11-12 13:56:13.449436');
INSERT INTO public.order_items VALUES (153, 'ORD052', 'P005', 1, 49000.00, 49000.00, NULL, '2025-11-12 14:37:25.243737');
INSERT INTO public.order_items VALUES (157, 'ORD055', 'P002', 1, 30000.00, 30000.00, NULL, '2025-11-12 14:52:57.433058');
INSERT INTO public.order_items VALUES (158, 'ORD056', 'P002', 1, 30000.00, 30000.00, NULL, '2025-11-12 15:19:48.379772');
INSERT INTO public.order_items VALUES (159, 'ORD057', 'P002', 1, 30000.00, 30000.00, NULL, '2025-11-12 15:55:02.197189');
INSERT INTO public.order_items VALUES (160, 'ORD058', 'P002', 1, 30000.00, 30000.00, NULL, '2025-11-12 15:55:22.078292');
INSERT INTO public.order_items VALUES (161, 'ORD059', 'P002', 1, 30000.00, 30000.00, NULL, '2025-11-12 16:30:18.782408');
INSERT INTO public.order_items VALUES (162, 'ORD060', 'P002', 1, 30000.00, 30000.00, NULL, '2025-11-12 16:33:56.271075');
INSERT INTO public.order_items VALUES (163, 'ORD061', 'P002', 1, 30000.00, 30000.00, NULL, '2025-11-12 16:37:04.411983');
INSERT INTO public.order_items VALUES (164, 'ORD062', 'P002', 2, 30000.00, 60000.00, NULL, '2025-11-12 16:50:46.771518');
INSERT INTO public.order_items VALUES (165, 'ORD063', 'P002', 1, 30000.00, 30000.00, NULL, '2025-11-12 16:53:51.920454');
INSERT INTO public.order_items VALUES (166, 'ORD064', 'P002', 1, 30000.00, 30000.00, NULL, '2025-11-12 16:57:23.559578');
INSERT INTO public.order_items VALUES (167, 'ORD065', 'P002', 1, 30000.00, 30000.00, NULL, '2025-11-12 17:02:48.517579');
INSERT INTO public.order_items VALUES (168, 'ORD066', 'P002', 1, 30000.00, 30000.00, NULL, '2025-11-12 17:10:24.259885');
INSERT INTO public.order_items VALUES (169, 'ORD067', 'P002', 1, 30000.00, 30000.00, NULL, '2025-11-12 17:23:23.225183');
INSERT INTO public.order_items VALUES (170, 'ORD068', 'P002', 1, 30000.00, 30000.00, NULL, '2025-11-12 17:27:50.618169');
INSERT INTO public.order_items VALUES (171, 'ORD069', 'P002', 1, 30000.00, 30000.00, NULL, '2025-11-12 17:40:20.978755');
INSERT INTO public.order_items VALUES (172, 'ORD070', 'P002', 1, 30000.00, 30000.00, NULL, '2025-11-12 17:49:13.761937');
INSERT INTO public.order_items VALUES (173, 'ORD071', 'P002', 1, 30000.00, 30000.00, NULL, '2025-11-12 17:52:33.496873');
INSERT INTO public.order_items VALUES (44, 'ORD005', 'P004', 1, 35000.00, 35000.00, NULL, '2025-11-11 09:04:57.420972');
INSERT INTO public.order_items VALUES (45, 'ORD007', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-11 09:08:48.108572');
INSERT INTO public.order_items VALUES (46, 'ORD008', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-11 09:16:23.38298');
INSERT INTO public.order_items VALUES (47, 'ORD008', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-11 09:17:56.424698');
INSERT INTO public.order_items VALUES (48, 'ORD009', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-11 09:23:23.620692');
INSERT INTO public.order_items VALUES (49, 'ORD009', 'P005', 1, 49000.00, 49000.00, NULL, '2025-11-11 09:23:26.753229');
INSERT INTO public.order_items VALUES (50, 'ORD010', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-11 09:26:51.083732');
INSERT INTO public.order_items VALUES (51, 'ORD010', 'P005', 1, 49000.00, 49000.00, NULL, '2025-11-11 09:26:53.979208');
INSERT INTO public.order_items VALUES (52, 'ORD011', 'P002', 1, 30000.00, 30000.00, NULL, '2025-11-11 09:32:08.315293');
INSERT INTO public.order_items VALUES (53, 'ORD011', 'P002', 1, 30000.00, 30000.00, NULL, '2025-11-11 09:32:09.879258');
INSERT INTO public.order_items VALUES (54, 'ORD011', 'P002', 1, 30000.00, 30000.00, NULL, '2025-11-11 09:32:11.492472');
INSERT INTO public.order_items VALUES (55, 'ORD011', 'P002', 1, 30000.00, 30000.00, NULL, '2025-11-11 09:32:19.951925');
INSERT INTO public.order_items VALUES (56, 'ORD011', 'P002', 1, 30000.00, 30000.00, NULL, '2025-11-11 09:32:24.231736');
INSERT INTO public.order_items VALUES (59, 'ORD013', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-11 09:38:09.948842');
INSERT INTO public.order_items VALUES (60, 'ORD014', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-11 09:41:23.566259');
INSERT INTO public.order_items VALUES (61, 'ORD014', 'P005', 1, 49000.00, 49000.00, NULL, '2025-11-11 09:41:25.828111');
INSERT INTO public.order_items VALUES (102, 'ORD020', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-11 14:21:03.957249');
INSERT INTO public.order_items VALUES (66, 'ORD002', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-11 09:59:14.501944');
INSERT INTO public.order_items VALUES (69, 'ORD001', 'P005', 1, 49000.00, 49000.00, NULL, '2025-11-11 10:00:01.317408');
INSERT INTO public.order_items VALUES (70, 'ORD00002', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-11 10:00:15.608261');
INSERT INTO public.order_items VALUES (71, 'ORD00002', 'P005', 1, 49000.00, 49000.00, NULL, '2025-11-11 10:00:17.230958');
INSERT INTO public.order_items VALUES (72, 'ORD016', 'P005', 1, 49000.00, 49000.00, NULL, '2025-11-11 10:03:50.887308');
INSERT INTO public.order_items VALUES (73, 'ORD016', 'P004', 1, 35000.00, 35000.00, NULL, '2025-11-11 10:03:52.272017');
INSERT INTO public.order_items VALUES (74, 'ORD016', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-11 10:03:53.689759');
INSERT INTO public.order_items VALUES (75, 'ORD014', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-11 10:09:09.425405');
INSERT INTO public.order_items VALUES (76, 'ORD014', 'P012', 1, 55000.00, 55000.00, NULL, '2025-11-11 10:09:11.738031');
INSERT INTO public.order_items VALUES (77, 'ORD014', 'P012', 1, 55000.00, 55000.00, NULL, '2025-11-11 10:09:45.711753');
INSERT INTO public.order_items VALUES (78, 'ORD003', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-11 10:19:11.152983');
INSERT INTO public.order_items VALUES (79, 'ORD003', 'P005', 1, 49000.00, 49000.00, NULL, '2025-11-11 10:19:12.765906');
INSERT INTO public.order_items VALUES (80, 'ORD005', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-11 11:02:30.719351');
INSERT INTO public.order_items VALUES (81, 'ORD005', 'P005', 1, 49000.00, 49000.00, NULL, '2025-11-11 11:02:32.772101');
INSERT INTO public.order_items VALUES (82, 'ORD006', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-11 11:04:42.428306');
INSERT INTO public.order_items VALUES (83, 'ORD007', 'P005', 1, 49000.00, 49000.00, NULL, '2025-11-11 11:18:31.836354');
INSERT INTO public.order_items VALUES (84, 'ORD007', 'P011', 1, 52000.00, 52000.00, NULL, '2025-11-11 11:18:33.2263');
INSERT INTO public.order_items VALUES (85, 'ORD007', 'P012', 1, 55000.00, 55000.00, NULL, '2025-11-11 11:18:36.116716');
INSERT INTO public.order_items VALUES (86, 'ORD007', 'P016', 1, 32000.00, 32000.00, NULL, '2025-11-11 11:18:40.805867');
INSERT INTO public.order_items VALUES (87, 'ORD008', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-11 11:33:25.896355');
INSERT INTO public.order_items VALUES (88, 'ORD009', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-11 11:35:57.457612');
INSERT INTO public.order_items VALUES (89, 'ORD009', 'P004', 2, 35000.00, 70000.00, NULL, '2025-11-11 11:44:05.567926');
INSERT INTO public.order_items VALUES (90, 'ORD010', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-11 11:50:21.354779');
INSERT INTO public.order_items VALUES (92, 'ORD013', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-11 11:52:25.137203');
INSERT INTO public.order_items VALUES (93, 'ORD019', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-11 11:59:02.424037');
INSERT INTO public.order_items VALUES (95, 'ORD015', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-11 12:03:30.896289');
INSERT INTO public.order_items VALUES (97, 'ORD012', 'P003', 1, 38000.00, 38000.00, NULL, '2025-11-11 12:20:42.179017');
INSERT INTO public.order_items VALUES (98, 'ORD012', 'P006', 100, 55000.00, 5500000.00, NULL, '2025-11-11 14:12:11.541346');
INSERT INTO public.order_items VALUES (100, 'ORD020', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-11 14:21:03.583354');
INSERT INTO public.order_items VALUES (101, 'ORD020', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-11 14:21:03.753385');
INSERT INTO public.order_items VALUES (104, 'ORD002', 'P004', 1, 35000.00, 35000.00, NULL, '2025-11-11 15:10:57.265612');
INSERT INTO public.order_items VALUES (105, 'ORD022', 'P005', 1, 49000.00, 49000.00, NULL, '2025-11-11 15:11:23.75777');
INSERT INTO public.order_items VALUES (106, 'ORD022', 'P005', 1, 49000.00, 49000.00, NULL, '2025-11-11 15:11:26.295645');
INSERT INTO public.order_items VALUES (107, 'ORD023', 'P005', 4, 49000.00, 196000.00, NULL, '2025-11-11 15:11:49.150162');
INSERT INTO public.order_items VALUES (64, 'ORD001', 'P002', 3, 30000.00, 90000.00, NULL, '2025-11-11 09:45:43.048611');
INSERT INTO public.order_items VALUES (108, 'ORD024', 'P005', 1, 49000.00, 49000.00, NULL, '2025-11-11 15:54:00.049132');
INSERT INTO public.order_items VALUES (110, 'ORD024', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-11 15:57:40.402871');
INSERT INTO public.order_items VALUES (111, 'ORD024', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-11 15:57:44.31623');
INSERT INTO public.order_items VALUES (112, 'ORD021', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-11 15:58:21.180365');
INSERT INTO public.order_items VALUES (113, 'ORD025', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-11 15:58:30.04662');
INSERT INTO public.order_items VALUES (114, 'ORD018', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-11 15:59:55.493269');
INSERT INTO public.order_items VALUES (115, 'ORD017', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-11 16:01:17.368692');
INSERT INTO public.order_items VALUES (116, 'ORD027', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-12 02:08:03.467033');
INSERT INTO public.order_items VALUES (117, 'ORD028', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-12 02:32:58.823983');
INSERT INTO public.order_items VALUES (118, 'ORD028', 'P010', 4, 49000.00, 196000.00, NULL, '2025-11-12 02:33:02.141062');
INSERT INTO public.order_items VALUES (119, 'ORD029', 'P002', 4, 30000.00, 120000.00, NULL, '2025-11-12 02:33:11.537004');
INSERT INTO public.order_items VALUES (120, 'ORD030', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-12 03:53:01.188113');
INSERT INTO public.order_items VALUES (121, 'ORD030', 'P005', 1, 49000.00, 49000.00, NULL, '2025-11-12 03:53:02.401482');
INSERT INTO public.order_items VALUES (122, 'ORD029', 'P006', 11, 55000.00, 605000.00, NULL, '2025-11-12 04:09:33.875125');
INSERT INTO public.order_items VALUES (123, 'ORD026', 'P006', 6, 55000.00, 330000.00, NULL, '2025-11-12 04:09:54.292828');
INSERT INTO public.order_items VALUES (124, 'ORD032', 'P006', 7, 55000.00, 385000.00, NULL, '2025-11-12 04:15:26.078635');
INSERT INTO public.order_items VALUES (125, 'ORD032', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-12 04:15:27.551001');
INSERT INTO public.order_items VALUES (128, 'ORD033', 'P012', 1, 55000.00, 55000.00, NULL, '2025-11-12 04:18:40.841844');
INSERT INTO public.order_items VALUES (129, 'ORD033', 'P012', 1, 55000.00, 55000.00, NULL, '2025-11-12 04:18:41.284366');
INSERT INTO public.order_items VALUES (130, 'ORD033', 'P012', 1, 55000.00, 55000.00, NULL, '2025-11-12 04:18:42.784632');
INSERT INTO public.order_items VALUES (131, 'ORD034', 'P005', 1, 49000.00, 49000.00, NULL, '2025-11-12 05:09:03.258827');
INSERT INTO public.order_items VALUES (132, 'ORD035', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-12 05:11:05.104561');
INSERT INTO public.order_items VALUES (133, 'ORD036', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-12 05:15:59.956733');
INSERT INTO public.order_items VALUES (134, 'ORD037', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-12 05:42:22.018939');
INSERT INTO public.order_items VALUES (135, 'ORD040', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-12 05:47:35.866816');
INSERT INTO public.order_items VALUES (140, 'ORD041', 'P006', 4, 55000.00, 220000.00, NULL, '2025-11-12 05:51:25.258211');
INSERT INTO public.order_items VALUES (174, 'ORD072', 'P002', 1, 30000.00, 30000.00, NULL, '2025-11-12 17:54:35.822618');
INSERT INTO public.order_items VALUES (175, 'ORD073', 'P006', 2, 55000.00, 110000.00, NULL, '2025-11-12 18:00:08.282295');
INSERT INTO public.order_items VALUES (176, 'ORD073', 'P005', 1, 49000.00, 49000.00, NULL, '2025-11-12 18:01:03.965299');
INSERT INTO public.order_items VALUES (177, 'ORD073', 'P012', 1, 55000.00, 55000.00, NULL, '2025-11-12 18:01:05.70475');
INSERT INTO public.order_items VALUES (178, 'ORD075', 'P002', 1, 30000.00, 30000.00, NULL, '2025-11-12 19:47:05.585696');
INSERT INTO public.order_items VALUES (179, 'ORD082', 'P006', 1, 55000.00, 55000.00, NULL, '2025-11-12 19:51:36.838519');
INSERT INTO public.order_items VALUES (180, 'ORD082', 'P012', 1, 55000.00, 55000.00, NULL, '2025-11-12 19:51:45.280544');
INSERT INTO public.order_items VALUES (181, 'ORD082', 'P011', 2, 52000.00, 104000.00, NULL, '2025-11-12 19:51:50.120017');
INSERT INTO public.order_items VALUES (183, 'ORD083', 'P005', 3, 49000.00, 147000.00, NULL, '2025-11-12 20:29:38.442583');
INSERT INTO public.order_items VALUES (184, 'ORD083', 'P012', 4, 55000.00, 220000.00, NULL, '2025-11-12 20:30:12.511933');


--
-- TOC entry 5014 (class 0 OID 25076)
-- Dependencies: 221
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.orders VALUES ('ORD009', 1, 'Dine-in', 'Completed', 229000.00, 0.00, 'Cash', NULL, NULL, NULL, false, NULL, NULL, 229000.00, NULL, NULL, NULL, NULL, '2025-11-11 09:23:22.296015+07', '2025-11-11 11:44:51.966837+07');
INSERT INTO public.orders VALUES ('ORD052', 46, NULL, 'Processing', 109000.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, '2025-11-12 14:32:47.284815+07', '2025-11-12 14:39:05.840807+07');
INSERT INTO public.orders VALUES ('ORD010', 1, 'Dine-in', 'Completed', 159000.00, 0.00, 'Cash', NULL, NULL, NULL, false, NULL, NULL, 159000.00, NULL, NULL, NULL, NULL, '2025-11-11 09:26:49.793278+07', '2025-11-11 11:50:23.77421+07');
INSERT INTO public.orders VALUES ('ORD011', 1, 'Dine-in', 'Cancelled', 0.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-11 09:32:04.756709+07', '2025-11-11 11:51:21.128787+07');
INSERT INTO public.orders VALUES ('ORD018', 1, 'Dine-in', 'Completed', 55000.00, 0.00, 'Online Bankking', NULL, NULL, NULL, false, NULL, NULL, 55000.00, NULL, NULL, NULL, NULL, '2025-11-11 10:56:22.14622+07', '2025-11-11 16:01:01.239356+07');
INSERT INTO public.orders VALUES ('ORD013', 1, 'Dine-in', 'Completed', 110000.00, 0.00, 'Cash', NULL, NULL, NULL, false, NULL, NULL, 110000.00, NULL, NULL, NULL, NULL, '2025-11-11 09:38:08.210766+07', '2025-11-11 11:52:35.631105+07');
INSERT INTO public.orders VALUES ('ORD017', 1, 'Dine-in', 'Completed', 55000.00, 0.00, 'Cash', NULL, NULL, NULL, false, NULL, NULL, 55000.00, NULL, NULL, NULL, NULL, '2025-11-11 10:28:44.444514+07', '2025-11-11 16:01:19.671721+07');
INSERT INTO public.orders VALUES ('ORD019', 1, 'Dine-in', 'Completed', 55000.00, 0.00, 'Cash', NULL, NULL, NULL, false, NULL, NULL, 55000.00, NULL, NULL, NULL, NULL, '2025-11-11 11:59:01.138246+07', '2025-11-11 12:02:59.487361+07');
INSERT INTO public.orders VALUES ('ORD015', 1, 'Dine-in', 'Completed', 55000.00, 0.00, 'Cash', NULL, NULL, NULL, false, NULL, NULL, 55000.00, NULL, NULL, NULL, NULL, '2025-11-11 09:43:40.693733+07', '2025-11-11 12:03:45.903511+07');
INSERT INTO public.orders VALUES ('ORD053', 46, NULL, 'Processing', 79000.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, '2025-11-12 14:43:09.357332+07', '2025-11-12 14:43:21.286654+07');
INSERT INTO public.orders VALUES ('ORD001', 41, NULL, 'Completed', 354000.00, 0.00, 'Cash', NULL, NULL, NULL, true, NULL, NULL, 354000.00, NULL, NULL, NULL, NULL, '2025-11-10 18:49:37.868899+07', '2025-11-11 12:04:00.67465+07');
INSERT INTO public.orders VALUES ('ORD027', 1, 'Dine-in', 'Completed', 55000.00, 0.00, 'Cash', NULL, NULL, NULL, false, NULL, NULL, 55000.00, NULL, NULL, NULL, NULL, '2025-11-12 02:08:02.064286+07', '2025-11-12 02:08:05.600421+07');
INSERT INTO public.orders VALUES ('ORD012', 1, 'Dine-in', 'Completed', 5538000.00, 0.00, 'Cash', NULL, NULL, NULL, false, NULL, NULL, 5538000.00, NULL, NULL, NULL, NULL, '2025-11-11 09:37:56.294807+07', '2025-11-11 14:12:19.214363+07');
INSERT INTO public.orders VALUES ('ORD036', 1, 'Dine-in', 'Completed', 55000.00, 0.00, 'Cash', NULL, NULL, NULL, false, NULL, NULL, 55000.00, NULL, NULL, NULL, NULL, '2025-11-12 05:15:58.685163+07', '2025-11-12 05:23:13.20152+07');
INSERT INTO public.orders VALUES ('ORD028', 1, 'Dine-in', 'Completed', 251000.00, 0.00, 'Cash', NULL, NULL, NULL, false, NULL, NULL, 251000.00, NULL, NULL, NULL, NULL, '2025-11-12 02:32:57.164094+07', '2025-11-12 02:33:03.650094+07');
INSERT INTO public.orders VALUES ('ORD020', 1, 'Dine-in', 'Completed', 165000.00, 0.00, 'Cash', NULL, NULL, NULL, false, NULL, NULL, 165000.00, NULL, NULL, NULL, NULL, '2025-11-11 14:20:59.558257+07', '2025-11-11 14:21:07.464696+07');
INSERT INTO public.orders VALUES ('ORD005', 1, 'Dine-in', 'Completed', 139000.00, 0.00, 'Cash', NULL, NULL, NULL, false, NULL, NULL, 139000.00, NULL, NULL, NULL, NULL, '2025-11-11 09:04:54.401934+07', '2025-11-11 11:03:38.781851+07');
INSERT INTO public.orders VALUES ('ORD037', 46, 'Dine-in', 'Cancelled', 55000.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, 55000.00, NULL, NULL, NULL, NULL, '2025-11-12 05:42:18.77928+07', '2025-11-12 05:42:27.378475+07');
INSERT INTO public.orders VALUES ('ORD038', 46, 'Dine-in', 'Pending', 0.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-12 05:47:21.417188+07', '2025-11-12 05:47:21.417188+07');
INSERT INTO public.orders VALUES ('ORD030', 1, 'Dine-in', 'Cancelled', 104000.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, 104000.00, NULL, NULL, NULL, NULL, '2025-11-12 03:52:58.482935+07', '2025-11-12 03:53:03.93751+07');
INSERT INTO public.orders VALUES ('ORD002', 1, 'Dine-in', 'Completed', 90000.00, 0.00, 'Cash', 'Order test từ main', NULL, NULL, false, '123 Đường Test', '0123456789', 90000.00, 'Unpaid', NULL, NULL, NULL, '2025-11-11 09:04:07.103279+07', '2025-11-11 15:11:10.591091+07');
INSERT INTO public.orders VALUES ('ORD006', 1, 'Dine-in', 'Completed', 55000.00, 0.00, 'Cash', NULL, NULL, NULL, false, NULL, NULL, 55000.00, NULL, NULL, NULL, NULL, '2025-11-11 09:08:30.600971+07', '2025-11-11 11:06:23.926094+07');
INSERT INTO public.orders VALUES ('ORD00002', 1, 'Dine-in', 'Completed', 104000.00, 0.00, 'Cash', 'Order test từ main', NULL, NULL, false, '123 Đường Test', '0123456789', 104000.00, 'Unpaid', NULL, NULL, NULL, '2025-11-11 08:05:16.932423+07', '2025-11-11 10:00:19.017797+07');
INSERT INTO public.orders VALUES ('ORD029', 1, 'Dine-in', 'Completed', 725000.00, 0.00, 'Cash', NULL, NULL, NULL, false, NULL, NULL, 725000.00, NULL, NULL, NULL, NULL, '2025-11-12 02:33:08.046499+07', '2025-11-12 04:09:36.26618+07');
INSERT INTO public.orders VALUES ('ORD016', 1, 'Dine-in', 'Completed', 139000.00, 0.00, 'Cash', NULL, NULL, NULL, false, NULL, NULL, 139000.00, NULL, NULL, NULL, NULL, '2025-11-11 10:03:47.441442+07', '2025-11-11 10:03:59.950321+07');
INSERT INTO public.orders VALUES ('ORD022', 1, 'Dine-in', 'Completed', 98000.00, 0.00, 'Cash', NULL, NULL, NULL, false, NULL, NULL, 98000.00, NULL, NULL, NULL, NULL, '2025-11-11 15:11:20.423698+07', '2025-11-11 15:11:30.588981+07');
INSERT INTO public.orders VALUES ('ORD023', 1, 'Dine-in', 'Completed', 196000.00, 0.00, 'Cash', NULL, NULL, NULL, false, NULL, NULL, 196000.00, NULL, NULL, NULL, NULL, '2025-11-11 15:11:41.552951+07', '2025-11-11 15:11:50.907629+07');
INSERT INTO public.orders VALUES ('ORD014', 1, 'Dine-in', 'Completed', 269000.00, 0.00, 'Cash', NULL, NULL, NULL, false, NULL, NULL, 269000.00, NULL, NULL, NULL, NULL, '2025-11-11 09:41:22.285811+07', '2025-11-11 10:10:47.220758+07');
INSERT INTO public.orders VALUES ('ORD003', 1, 'Dine-in', 'Completed', 104000.00, 0.00, 'Cash', 'Order test từ main', NULL, NULL, false, '123 Đường Test', '0123456789', 104000.00, 'Unpaid', NULL, NULL, NULL, '2025-11-11 09:04:14.492323+07', '2025-11-11 10:19:14.369505+07');
INSERT INTO public.orders VALUES ('ORD004', 1, 'Dine-in', 'Cancelled', 0.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-11 09:04:48.058185+07', '2025-11-11 10:30:11.345262+07');
INSERT INTO public.orders VALUES ('ORD007', 1, 'Dine-in', 'Completed', 243000.00, 0.00, 'Cash', NULL, NULL, NULL, false, NULL, NULL, 243000.00, NULL, NULL, NULL, NULL, '2025-11-11 09:08:46.945341+07', '2025-11-11 11:29:45.399645+07');
INSERT INTO public.orders VALUES ('ORD024', 1, 'Dine-in', 'Completed', 159000.00, 0.00, 'Cash', NULL, NULL, NULL, false, NULL, NULL, 159000.00, NULL, NULL, NULL, NULL, '2025-11-11 15:53:57.265277+07', '2025-11-11 15:58:05.443569+07');
INSERT INTO public.orders VALUES ('ORD008', 1, 'Dine-in', 'Completed', 165000.00, 0.00, 'Cash', NULL, NULL, NULL, false, NULL, NULL, 165000.00, NULL, NULL, NULL, NULL, '2025-11-11 09:16:21.485293+07', '2025-11-11 11:33:28.214531+07');
INSERT INTO public.orders VALUES ('ORD040', 46, 'Dine-in', 'Completed', 55000.00, 0.00, 'Cash', NULL, NULL, NULL, false, NULL, NULL, 55000.00, NULL, NULL, NULL, NULL, '2025-11-12 05:47:34.207605+07', '2025-11-12 05:47:50.55108+07');
INSERT INTO public.orders VALUES ('ORD021', 1, 'Dine-in', 'Completed', 55000.00, 0.00, 'Cash', NULL, NULL, NULL, false, NULL, NULL, 55000.00, NULL, NULL, NULL, NULL, '2025-11-11 14:27:29.104004+07', '2025-11-11 15:58:23.946009+07');
INSERT INTO public.orders VALUES ('ORD032', 1, 'Dine-in', 'Completed', 440000.00, 0.00, 'Cash', NULL, NULL, NULL, false, NULL, NULL, 440000.00, NULL, NULL, NULL, NULL, '2025-11-12 04:15:22.537756+07', '2025-11-12 04:15:29.850846+07');
INSERT INTO public.orders VALUES ('ORD025', 1, 'Dine-in', 'Completed', 55000.00, 0.00, 'Cash', NULL, NULL, NULL, false, NULL, NULL, 55000.00, NULL, NULL, NULL, NULL, '2025-11-11 15:58:28.470808+07', '2025-11-11 15:59:33.727634+07');
INSERT INTO public.orders VALUES ('ORD031', 1, 'Dine-in', 'Pending', 55000.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, 55000.00, NULL, NULL, NULL, NULL, '2025-11-12 04:14:53.686308+07', '2025-11-12 04:16:13.455769+07');
INSERT INTO public.orders VALUES ('ORD045', 46, 'Dine-in', 'Cancelled', 0.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-12 08:01:38.481124+07', '2025-11-12 08:01:46.065354+07');
INSERT INTO public.orders VALUES ('ORD054', 46, NULL, 'Processing', 60000.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, '2025-11-12 14:43:36.561074+07', '2025-11-12 14:48:57.992873+07');
INSERT INTO public.orders VALUES ('ORD033', 1, 'Dine-in', 'Completed', 165000.00, 0.00, 'Online Bankking', NULL, NULL, NULL, false, NULL, NULL, 165000.00, NULL, NULL, NULL, NULL, '2025-11-12 04:18:36.792943+07', '2025-11-12 04:18:45.99172+07');
INSERT INTO public.orders VALUES ('ORD043', 46, 'Dine-in', 'Completed', 49000.00, 0.00, 'Online Bankking', NULL, NULL, NULL, false, NULL, NULL, 49000.00, NULL, NULL, NULL, NULL, '2025-11-12 07:53:02.415508+07', '2025-11-12 08:03:50.463384+07');
INSERT INTO public.orders VALUES ('ORD034', 1, 'Dine-in', 'Completed', 49000.00, 0.00, 'Cash', NULL, NULL, NULL, false, NULL, NULL, 49000.00, NULL, NULL, NULL, NULL, '2025-11-12 05:09:00.686818+07', '2025-11-12 05:09:53.089646+07');
INSERT INTO public.orders VALUES ('ORD035', 1, 'Dine-in', 'Completed', 55000.00, 0.00, 'Cash', NULL, NULL, NULL, false, NULL, NULL, 55000.00, NULL, NULL, NULL, NULL, '2025-11-12 05:11:03.928226+07', '2025-11-12 05:11:06.414601+07');
INSERT INTO public.orders VALUES ('ORD055', 46, NULL, 'Processing', 60000.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, '2025-11-12 14:52:26.764475+07', '2025-11-12 14:53:28.325633+07');
INSERT INTO public.orders VALUES ('ORD044', 46, 'Dine-in', 'Cancelled', 104000.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, 104000.00, NULL, NULL, NULL, NULL, '2025-11-12 07:59:18.416036+07', '2025-11-12 08:24:41.120066+07');
INSERT INTO public.orders VALUES ('ORD047', 46, 'Dine-in', 'Pending', 0.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-12 09:10:19.543558+07', '2025-11-12 09:10:19.543558+07');
INSERT INTO public.orders VALUES ('ORD041', 46, 'Dine-in', 'Completed', 220000.00, 0.00, 'Cash', NULL, NULL, NULL, false, NULL, NULL, 220000.00, NULL, NULL, NULL, NULL, '2025-11-12 05:49:38.076372+07', '2025-11-12 06:20:27.586717+07');
INSERT INTO public.orders VALUES ('ORD039', 46, 'Dine-in', 'Pending', 490000.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, 490000.00, NULL, NULL, NULL, NULL, '2025-11-12 05:47:28.321922+07', '2025-11-12 06:20:40.915394+07');
INSERT INTO public.orders VALUES ('ORD046', 46, 'Dine-in', 'Pending', 110000.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, 110000.00, NULL, NULL, NULL, NULL, '2025-11-12 09:10:12.13833+07', '2025-11-12 09:10:38.093596+07');
INSERT INTO public.orders VALUES ('ORD048', 46, 'Dine-in', 'Pending', 0.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-12 09:20:52.259317+07', '2025-11-12 09:20:52.259317+07');
INSERT INTO public.orders VALUES ('ORD026', 46, NULL, 'Processing', 360000.00, 0.00, 'Online Bankking', NULL, NULL, NULL, false, NULL, NULL, 330000.00, 'Pending', NULL, NULL, NULL, '2025-11-12 02:06:15.050235+07', '2025-11-12 13:46:39.768475+07');
INSERT INTO public.orders VALUES ('ORD042', 46, 'Dine-in', 'Completed', 159000.00, 0.00, 'Cash', NULL, NULL, NULL, false, NULL, NULL, 159000.00, NULL, NULL, NULL, NULL, '2025-11-12 06:30:26.78964+07', '2025-11-12 06:30:38.069396+07');
INSERT INTO public.orders VALUES ('ORD049', 46, NULL, 'Processing', 60000.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, '2025-11-12 13:50:08.069588+07', '2025-11-12 13:50:22.537312+07');
INSERT INTO public.orders VALUES ('ORD050', 46, NULL, 'Processing', 79000.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, '2025-11-12 13:53:07.855406+07', '2025-11-12 13:53:23.652372+07');
INSERT INTO public.orders VALUES ('ORD051', 46, NULL, 'Processing', 60000.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, '2025-11-12 13:56:09.325817+07', '2025-11-12 14:31:43.098955+07');
INSERT INTO public.orders VALUES ('ORD056', 46, NULL, 'Processing', 60000.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, '2025-11-12 15:19:44.823713+07', '2025-11-12 15:19:53.370265+07');
INSERT INTO public.orders VALUES ('ORD057', 46, NULL, 'Processing', 60000.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, '2025-11-12 15:54:51.125634+07', '2025-11-12 15:55:06.419179+07');
INSERT INTO public.orders VALUES ('ORD058', 46, NULL, 'Processing', 60000.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, '2025-11-12 15:55:11.602399+07', '2025-11-12 15:55:27.031479+07');
INSERT INTO public.orders VALUES ('ORD059', 46, NULL, 'Processing', 60000.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, '2025-11-12 16:30:14.577094+07', '2025-11-12 16:30:22.543855+07');
INSERT INTO public.orders VALUES ('ORD060', 46, NULL, 'Processing', 60000.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, '2025-11-12 16:33:52.349418+07', '2025-11-12 16:34:01.544312+07');
INSERT INTO public.orders VALUES ('ORD061', 46, NULL, 'Processing', 60000.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, '2025-11-12 16:37:00.179183+07', '2025-11-12 16:37:08.373147+07');
INSERT INTO public.orders VALUES ('ORD062', 46, NULL, 'Processing', 90000.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, '2025-11-12 16:50:40.190384+07', '2025-11-12 16:50:53.592155+07');
INSERT INTO public.orders VALUES ('ORD063', 46, NULL, 'Processing', 60000.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, '2025-11-12 16:53:47.316713+07', '2025-11-12 16:53:56.198681+07');
INSERT INTO public.orders VALUES ('ORD064', 46, NULL, 'Processing', 60000.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, '2025-11-12 16:57:20.719235+07', '2025-11-12 16:57:35.882492+07');
INSERT INTO public.orders VALUES ('ORD065', 46, NULL, 'Processing', 60000.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, '2025-11-12 17:02:43.14174+07', '2025-11-12 17:02:52.955042+07');
INSERT INTO public.orders VALUES ('ORD066', 46, NULL, 'Processing', 60000.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, '2025-11-12 17:10:19.062627+07', '2025-11-12 17:10:28.54028+07');
INSERT INTO public.orders VALUES ('ORD067', 46, NULL, 'Processing', 60000.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, '2025-11-12 17:23:17.890736+07', '2025-11-12 17:23:27.526951+07');
INSERT INTO public.orders VALUES ('ORD068', 46, NULL, 'Processing', 60000.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, '2025-11-12 17:27:45.236656+07', '2025-11-12 17:27:57.434614+07');
INSERT INTO public.orders VALUES ('ORD069', 46, NULL, 'Processing', 60000.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, '2025-11-12 17:40:17.093673+07', '2025-11-12 17:40:27.242249+07');
INSERT INTO public.orders VALUES ('ORD070', 46, NULL, 'Processing', 60000.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, '2025-11-12 17:49:09.818708+07', '2025-11-12 17:49:18.181056+07');
INSERT INTO public.orders VALUES ('ORD071', 46, NULL, 'Processing', 60000.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, '2025-11-12 17:52:30.140552+07', '2025-11-12 17:52:38.237551+07');
INSERT INTO public.orders VALUES ('ORD072', 46, NULL, 'Processing', 60000.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, '2025-11-12 17:54:31.779462+07', '2025-11-12 17:54:39.985598+07');
INSERT INTO public.orders VALUES ('ORD073', 46, 'Dine-in', 'Completed', 214000.00, 0.00, 'Cash', NULL, NULL, NULL, false, NULL, NULL, 214000.00, NULL, NULL, NULL, NULL, '2025-11-12 18:00:01.176988+07', '2025-11-12 19:22:40.467754+07');
INSERT INTO public.orders VALUES ('ORD074', 46, 'Dine-in', 'Pending', 0.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-12 19:26:24.25728+07', '2025-11-12 19:26:24.25728+07');
INSERT INTO public.orders VALUES ('ORD075', 46, NULL, 'Processing', 60000.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, '2025-11-12 19:47:01.223998+07', '2025-11-12 19:47:09.464305+07');
INSERT INTO public.orders VALUES ('ORD076', 46, 'Dine-in', 'Pending', 0.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-12 19:48:44.214472+07', '2025-11-12 19:48:44.214472+07');
INSERT INTO public.orders VALUES ('ORD077', 46, 'Dine-in', 'Pending', 0.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-12 19:49:07.490511+07', '2025-11-12 19:49:07.490511+07');
INSERT INTO public.orders VALUES ('ORD078', 46, 'Dine-in', 'Pending', 0.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-12 19:49:17.564785+07', '2025-11-12 19:49:17.564785+07');
INSERT INTO public.orders VALUES ('ORD079', 46, 'Dine-in', 'Pending', 0.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-12 19:49:18.583789+07', '2025-11-12 19:49:18.583789+07');
INSERT INTO public.orders VALUES ('ORD080', 46, 'Dine-in', 'Pending', 0.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-12 19:49:19.008486+07', '2025-11-12 19:49:19.008486+07');
INSERT INTO public.orders VALUES ('ORD081', 46, 'Dine-in', 'Pending', 0.00, 0.00, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-12 19:49:27.581076+07', '2025-11-12 19:49:27.581076+07');
INSERT INTO public.orders VALUES ('ORD082', 46, 'Dine-in', 'Pending', 214000.00, 0.00, NULL, '123', NULL, NULL, false, NULL, NULL, 214000.00, NULL, NULL, NULL, NULL, '2025-11-12 19:51:21.100772+07', '2025-11-12 20:16:44.259693+07');
INSERT INTO public.orders VALUES ('ORD083', 46, 'Dine-in', 'Cancelled', 367000.00, 0.00, NULL, '1111111', NULL, NULL, false, NULL, NULL, 367000.00, NULL, NULL, NULL, NULL, '2025-11-12 20:18:17.333508+07', '2025-11-12 20:30:23.650761+07');


--
-- TOC entry 5019 (class 0 OID 25138)
-- Dependencies: 226
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5012 (class 0 OID 25039)
-- Dependencies: 219
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.products VALUES ('P001', 'Cà phê sữa đá', 'Cà phê', 'Cà phê phin truyền thống với sữa đặc, phong cách Sài Gòn.', 35000.00, true, 'Activate', 'https://example.com/vn/ca-phe-sua-da.jpg', 120, 'Best-seller buổi sáng', '2025-11-10 18:17:02.411978+07', '2025-11-10 18:17:02.411978+07');
INSERT INTO public.products VALUES ('P002', 'Cà phê đen đá', 'Cà phê', 'Cà phê phin đen, đậm vị, phù hợp người thích ít ngọt.', 30000.00, true, 'Activate', 'https://example.com/vn/ca-phe-den-da.jpg', 110, 'Khách văn phòng ưa chuộng', '2025-11-10 18:17:02.411978+07', '2025-11-10 18:17:02.411978+07');
INSERT INTO public.products VALUES ('P003', 'Bạc xỉu', 'Cà phê', 'Cà phê sữa nhiều sữa, ít cà phê, vị béo ngọt dễ uống.', 38000.00, true, 'Activate', 'https://example.com/vn/bac-xiu.jpg', 90, 'Giới trẻ rất thích', '2025-11-10 18:17:02.411978+07', '2025-11-10 18:17:02.411978+07');
INSERT INTO public.products VALUES ('P004', 'Cà phê phin nóng', 'Cà phê', 'Cà phê phin rang xay, phục vụ nóng, hương thơm đậm đà.', 35000.00, false, 'Activate', 'https://example.com/vn/ca-phe-phin-nong.jpg', 80, NULL, '2025-11-10 18:17:02.411978+07', '2025-11-10 18:17:02.411978+07');
INSERT INTO public.products VALUES ('P005', 'Cold brew cam sả', 'Cà phê', 'Cà phê cold brew ủ lạnh, mix cam sả, phong cách hiện đại.', 49000.00, true, 'Activate', 'https://example.com/vn/cold-brew-cam-sa.jpg', 70, 'Món signature của quán', '2025-11-10 18:17:02.411978+07', '2025-11-10 18:17:02.411978+07');
INSERT INTO public.products VALUES ('P006', 'Latte caramel', 'Cà phê máy', 'Latte pha máy với sốt caramel, vị béo và thơm.', 55000.00, false, 'Activate', 'https://example.com/vn/latte-caramel.jpg', 60, NULL, '2025-11-10 18:17:02.411978+07', '2025-11-10 18:17:02.411978+07');
INSERT INTO public.products VALUES ('P007', 'Cappuccino', 'Cà phê máy', 'Espresso với sữa nóng và lớp foam mịn, chuẩn phong cách Ý.', 52000.00, false, 'Activate', 'https://example.com/vn/cappuccino.jpg', 60, NULL, '2025-11-10 18:17:02.411978+07', '2025-11-10 18:17:02.411978+07');
INSERT INTO public.products VALUES ('P008', 'Trà đào cam sả', 'Trà trái cây', 'Trà đào kèm cam tươi và sả, lấy cảm hứng từ The Coffee House.', 49000.00, true, 'Activate', 'https://example.com/vn/tra-dao-cam-sa.jpg', 100, 'Món quốc dân ngày nóng', '2025-11-10 18:17:02.411978+07', '2025-11-10 18:17:02.411978+07');
INSERT INTO public.products VALUES ('P009', 'Trà sen vàng', 'Trà', 'Trà xanh hoa lài kèm hạt sen, phong cách Phúc Long.', 45000.00, false, 'Activate', 'https://example.com/vn/tra-sen-vang.jpg', 80, NULL, '2025-11-10 18:17:02.411978+07', '2025-11-10 18:17:02.411978+07');
INSERT INTO public.products VALUES ('P010', 'Trà sữa trân châu đường đen', 'Trà sữa', 'Trà sữa béo, trân châu đường đen nấu kiểu Đài Loan.', 49000.00, true, 'Activate', 'https://example.com/vn/tra-sua-tran-chau.jpg', 90, 'Khung giờ chiều rất chạy', '2025-11-10 18:17:02.411978+07', '2025-11-10 18:17:02.411978+07');
INSERT INTO public.products VALUES ('P011', 'Hồng trà sữa phô mai', 'Trà sữa', 'Hồng trà đậm, kem phô mai mặn mà, béo nhẹ.', 52000.00, false, 'Activate', 'https://example.com/vn/hong-tra-sua-pho-mai.jpg', 70, NULL, '2025-11-10 18:17:02.411978+07', '2025-11-10 18:17:02.411978+07');
INSERT INTO public.products VALUES ('P012', 'Matcha latte', 'Trà', 'Matcha Nhật Bản kết hợp sữa tươi, vị đăng đắng nhẹ.', 55000.00, false, 'Activate', 'https://example.com/vn/matcha-latte.jpg', 60, NULL, '2025-11-10 18:17:02.411978+07', '2025-11-10 18:17:02.411978+07');
INSERT INTO public.products VALUES ('P013', 'Nước ép cam tươi', 'Nước ép', 'Cam tươi vắt tại quán, không đường hoặc ít đường theo yêu cầu.', 39000.00, false, 'Activate', 'https://example.com/vn/nuoc-ep-cam.jpg', 100, NULL, '2025-11-10 18:17:02.411978+07', '2025-11-10 18:17:02.411978+07');
INSERT INTO public.products VALUES ('P014', 'Nước ép dứa chanh', 'Nước ép', 'Nước ép dứa mix chanh, chua ngọt dễ uống.', 39000.00, false, 'Activate', 'https://example.com/vn/nuoc-ep-dua-chanh.jpg', 80, NULL, '2025-11-10 18:17:02.411978+07', '2025-11-10 18:17:02.411978+07');
INSERT INTO public.products VALUES ('P015', 'Sinh tố xoài', 'Sinh tố', 'Sinh tố xoài chín, béo nhẹ, topping dừa khô.', 45000.00, false, 'Activate', 'https://example.com/vn/sinh-to-xoai.jpg', 70, NULL, '2025-11-10 18:17:02.411978+07', '2025-11-10 18:17:02.411978+07');
INSERT INTO public.products VALUES ('P016', 'Bánh croissant bơ', 'Bánh ngọt', 'Croissant bơ nóng giòn, dùng kèm cà phê rất hợp.', 32000.00, false, 'Activate', 'https://example.com/vn/croissant.jpg', 60, 'Nướng mới mỗi sáng', '2025-11-10 18:17:02.411978+07', '2025-11-10 18:17:02.411978+07');
INSERT INTO public.products VALUES ('P017', 'Bánh mì pate trứng', 'Đồ ăn vặt', 'Bánh mì pate, chả, trứng ốp la, phong cách vỉa hè Hà Nội.', 39000.00, false, 'Activate', 'https://example.com/vn/banh-mi-pate.jpg', 50, NULL, '2025-11-10 18:17:02.411978+07', '2025-11-10 18:17:02.411978+07');
INSERT INTO public.products VALUES ('P018', 'Bánh tiramisu', 'Bánh ngọt', 'Tiramisu vị cà phê, mềm, béo nhẹ, hợp uống kèm espresso.', 49000.00, false, 'Activate', 'https://example.com/vn/tiramisu.jpg', 40, NULL, '2025-11-10 18:17:02.411978+07', '2025-11-10 18:17:02.411978+07');
INSERT INTO public.products VALUES ('P019', 'Cheesecake chanh dây', 'Bánh ngọt', 'Bánh phô mai chanh dây, chua ngọt, không ngấy.', 52000.00, false, 'Activate', 'https://example.com/vn/cheesecake-chanh-day.jpg', 40, NULL, '2025-11-10 18:17:02.411978+07', '2025-11-10 18:17:02.411978+07');
INSERT INTO public.products VALUES ('P020', 'Combo cà phê sữa đá + croissant', 'Combo', 'Combo sáng: cà phê sữa đá + croissant bơ.', 65000.00, true, 'Activate', 'https://example.com/vn/combo-sang.jpg', 80, 'Ưu đãi khung giờ 7h–10h', '2025-11-10 18:17:02.411978+07', '2025-11-10 18:17:02.411978+07');


--
-- TOC entry 5022 (class 0 OID 25170)
-- Dependencies: 229
-- Data for Name: promotion_products; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5013 (class 0 OID 25052)
-- Dependencies: 220
-- Data for Name: promotions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.promotions VALUES ('PR001', 'ABC12ABC', 'GIảm giá test 1', 'fixed_amount', 20000.00, 2000.00, '2025-11-10', '2025-11-21', 'Activate', true, NULL, 0, 'MÃ giảm giá đầu tiên', '', NULL, NULL, NULL, '2025-11-12 08:26:41.25533+07', '2025-11-12 08:26:41.25533+07');


--
-- TOC entry 5017 (class 0 OID 25120)
-- Dependencies: 224
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5011 (class 0 OID 25026)
-- Dependencies: 218
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users VALUES (21, 'admin@yencoffee.vn', '5E884898...:SALT001', 'Nguyễn Công Minh', 'ADMIN', 'Active', NULL, 'Quản trị hệ thống YEN Coffee', '2024-11-10 18:16:44.889078+07', '2025-11-10 18:16:44.889078+07');
INSERT INTO public.users VALUES (22, 'hr1@yencoffee.vn', '5E884898...:SALT002', 'Trần Thu Hà', 'HR', 'Active', NULL, 'Phụ trách tuyển dụng', '2024-12-25 18:16:44.889078+07', '2025-11-10 18:16:44.889078+07');
INSERT INTO public.users VALUES (23, 'hr2@yencoffee.vn', '5E884898...:SALT003', 'Phạm Quang Huy', 'HR', 'Active', NULL, NULL, '2025-01-14 18:16:44.889078+07', '2025-11-10 18:16:44.889078+07');
INSERT INTO public.users VALUES (24, 'cashier1@yencoffee.vn', '5E884898...:SALT004', 'Lê Thị Mai', 'CASHIER', 'Active', NULL, 'Thu ngân ca sáng', '2025-02-03 18:16:44.889078+07', '2025-11-10 18:16:44.889078+07');
INSERT INTO public.users VALUES (25, 'cashier2@yencoffee.vn', '5E884898...:SALT005', 'Hoàng Anh Tuấn', 'CASHIER', 'Active', NULL, 'Thu ngân ca tối', '2025-02-23 18:16:44.889078+07', '2025-11-10 18:16:44.889078+07');
INSERT INTO public.users VALUES (26, 'cashier3@yencoffee.vn', '5E884898...:SALT006', 'Vũ Ngọc Ánh', 'CASHIER', 'Active', NULL, NULL, '2025-03-15 18:16:44.889078+07', '2025-11-10 18:16:44.889078+07');
INSERT INTO public.users VALUES (27, 'marketer1@yencoffee.vn', '5E884898...:SALT007', 'Đỗ Khánh Linh', 'MARKETER', 'Active', NULL, 'Quản lý fanpage & TikTok', '2025-04-04 18:16:44.889078+07', '2025-11-10 18:16:44.889078+07');
INSERT INTO public.users VALUES (28, 'marketer2@yencoffee.vn', '5E884898...:SALT008', 'Bùi Minh Khoa', 'MARKETER', 'Active', NULL, 'Chạy quảng cáo Facebook', '2025-04-24 18:16:44.889078+07', '2025-11-10 18:16:44.889078+07');
INSERT INTO public.users VALUES (29, 'khach1@gmail.com', '5E884898...:SALT009', 'Nguyễn Văn Nam', 'CUSTOMER', 'Active', NULL, 'Khách quen khu Cầu Giấy', '2025-05-14 18:16:44.889078+07', '2025-11-10 18:16:44.889078+07');
INSERT INTO public.users VALUES (30, 'khach2@gmail.com', '5E884898...:SALT010', 'Lê Thu Thảo', 'CUSTOMER', 'Active', NULL, NULL, '2025-05-24 18:16:44.889078+07', '2025-11-10 18:16:44.889078+07');
INSERT INTO public.users VALUES (31, 'khach3@gmail.com', '5E884898...:SALT011', 'Phạm Tuấn Anh', 'CUSTOMER', 'Active', NULL, 'Đặt hàng qua app ShopeeFood', '2025-06-03 18:16:44.889078+07', '2025-11-10 18:16:44.889078+07');
INSERT INTO public.users VALUES (32, 'khach4@gmail.com', '5E884898...:SALT012', 'Vũ Thị Hương', 'CUSTOMER', 'Active', NULL, NULL, '2025-06-13 18:16:44.889078+07', '2025-11-10 18:16:44.889078+07');
INSERT INTO public.users VALUES (33, 'khach5@gmail.com', '5E884898...:SALT013', 'Trần Đức Long', 'CUSTOMER', 'Active', NULL, 'Sinh viên FPT Hà Nội', '2025-06-23 18:16:44.889078+07', '2025-11-10 18:16:44.889078+07');
INSERT INTO public.users VALUES (34, 'khach6@gmail.com', '5E884898...:SALT014', 'Hoàng Lan Chi', 'CUSTOMER', 'Active', NULL, NULL, '2025-07-03 18:16:44.889078+07', '2025-11-10 18:16:44.889078+07');
INSERT INTO public.users VALUES (35, 'khach7@gmail.com', '5E884898...:SALT015', 'Ngô Minh Quân', 'CUSTOMER', 'Active', NULL, NULL, '2025-07-13 18:16:44.889078+07', '2025-11-10 18:16:44.889078+07');
INSERT INTO public.users VALUES (36, 'khach8@gmail.com', '5E884898...:SALT016', 'Phan Thị Trang', 'CUSTOMER', 'Active', NULL, 'Thường đặt trà sữa', '2025-07-23 18:16:44.889078+07', '2025-11-10 18:16:44.889078+07');
INSERT INTO public.users VALUES (37, 'khach9@gmail.com', '5E884898...:SALT017', 'Cao Văn Khải', 'CUSTOMER', 'Inactive', NULL, 'Tạm khóa do lâu không dùng', '2025-08-02 18:16:44.889078+07', '2025-11-10 18:16:44.889078+07');
INSERT INTO public.users VALUES (38, 'khach10@gmail.com', '5E884898...:SALT018', 'Đinh Thị Yến', 'CUSTOMER', 'Active', NULL, NULL, '2025-08-12 18:16:44.889078+07', '2025-11-10 18:16:44.889078+07');
INSERT INTO public.users VALUES (39, 'khach11@gmail.com', '5E884898...:SALT019', 'Kiều Quốc Bảo', 'CUSTOMER', 'Active', NULL, NULL, '2025-08-22 18:16:44.889078+07', '2025-11-10 18:16:44.889078+07');
INSERT INTO public.users VALUES (40, 'khach12@gmail.com', '5E884898...:SALT020', 'Lý Thu Uyên', 'CUSTOMER', 'Blocked', NULL, 'Trả hàng nhiều lần', '2025-09-01 18:16:44.889078+07', '2025-11-10 18:16:44.889078+07');
INSERT INTO public.users VALUES (43, 'customerOffline@gmail.vn', '5E884898...:SALT001', 'Khách Offline', 'Customer', 'Active', NULL, 'Bản ghi dành cho khác offlien', '2024-11-11 08:01:22.65363+07', '2025-11-11 08:01:22.65363+07');
INSERT INTO public.users VALUES (1, 'customerOffline2@gmail.vn', '5E884898...:SALT001', 'Khách Offline', 'Customer', 'Active', NULL, 'Bản ghi dành cho khác offlien', '2024-11-11 08:05:08.333998+07', '2025-11-11 08:05:08.333998+07');
INSERT INTO public.users VALUES (44, 'huhu13999@gmail.com', '517685548B55A59706714ED06CF8D9125E83F15BAA3E4744258984B4C90B63A1:c5ca0a0c-5dce-4d6e-b214-6929e8084230', 'Do                                                                                                                                                                Tuấn Hưng@', 'CUSTOMER', 'Active', NULL, NULL, '2025-11-11 16:25:49.160549+07', '2025-11-11 16:25:49.160549+07');
INSERT INTO public.users VALUES (45, 'zoanhok@gmail.com', '9DFE1385474424022AF5159B2378C6870D652DCF83280D73BB79A4F24CB90B2B:c94a039c-9758-49de-97e5-c6ffbd127ab3', 'DatNT', 'CUSTOMER', 'Active', NULL, NULL, '2025-11-11 16:27:31.235099+07', '2025-11-11 16:27:31.235099+07');
INSERT INTO public.users VALUES (41, 'ducto352@gmail.com', '14BD251D0C01349E315B30629A66225D11E34B80B43A3A8074F37B537350BB0E:170142ce-cfbf-40ec-b4e2-ddd26b60ff02', 'Đức', 'CASHIER', 'Active', NULL, NULL, '2025-11-10 18:49:32.35392+07', '2025-11-10 18:49:32.35392+07');
INSERT INTO public.users VALUES (47, 'ducto25@gmail.com', '07EA57AD101524BA2C7B6A7A1B651A87CC5E025FD955D0EAB5B1A156A779C25A:70373412-a4d8-45a1-8918-e5dce591dd94', 'a', 'CUSTOMER', 'Active', NULL, NULL, '2025-11-12 06:34:07.351526+07', '2025-11-12 06:34:07.351526+07');
INSERT INTO public.users VALUES (48, 'longhahoang14@gmail.com', '12E9D9C66BDAE4F1E255E5CC888742132333426AD5AE225CDD526DEFE884F2D4:65512cd7-60fd-46ed-80d9-627b9d8bb1bc', 'a', 'CUSTOMER', 'Activate', NULL, NULL, '2025-11-12 06:51:14.651471+07', '2025-11-12 06:51:14.651471+07');
INSERT INTO public.users VALUES (46, 'ducto35@gmail.com', 'F50D23B21CC0DA856813BEDD312AB4ED840FE7B143AA4EDBD5D9EFA95005B377:f103a4ac-cbfa-4190-be1d-db1e84784c26', 'Đức', 'CASHIER', 'Active', NULL, NULL, '2025-11-12 02:06:10.24819+07', '2025-11-12 02:06:10.24819+07');


--
-- TOC entry 5033 (class 0 OID 0)
-- Dependencies: 227
-- Name: invoices_invoice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.invoices_invoice_id_seq', 1, false);


--
-- TOC entry 5034 (class 0 OID 0)
-- Dependencies: 222
-- Name: order_items_order_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_items_order_item_id_seq', 184, true);


--
-- TOC entry 5035 (class 0 OID 0)
-- Dependencies: 225
-- Name: payments_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payments_payment_id_seq', 1, false);


--
-- TOC entry 5036 (class 0 OID 0)
-- Dependencies: 217
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 48, true);


--
-- TOC entry 4847 (class 2606 OID 25164)
-- Name: invoices invoices_invoice_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_invoice_number_key UNIQUE (invoice_number);


--
-- TOC entry 4849 (class 2606 OID 25162)
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (invoice_id);


--
-- TOC entry 4837 (class 2606 OID 25109)
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (order_item_id);


--
-- TOC entry 4833 (class 2606 OID 25088)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- TOC entry 4845 (class 2606 OID 25146)
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (payment_id);


--
-- TOC entry 4820 (class 2606 OID 25050)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);


--
-- TOC entry 4853 (class 2606 OID 25175)
-- Name: promotion_products promotion_products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_products
    ADD CONSTRAINT promotion_products_pkey PRIMARY KEY (promotion_id, product_id);


--
-- TOC entry 4825 (class 2606 OID 25065)
-- Name: promotions promotions_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT promotions_code_key UNIQUE (code);


--
-- TOC entry 4827 (class 2606 OID 25063)
-- Name: promotions promotions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT promotions_pkey PRIMARY KEY (promotion_id);


--
-- TOC entry 4841 (class 2606 OID 25131)
-- Name: settings settings_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_name_key UNIQUE (name);


--
-- TOC entry 4843 (class 2606 OID 25129)
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (setting_id);


--
-- TOC entry 4813 (class 2606 OID 25038)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4815 (class 2606 OID 25036)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 4834 (class 1259 OID 25196)
-- Name: idx_order_items_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_order_items_order_id ON public.order_items USING btree (order_id);


--
-- TOC entry 4835 (class 1259 OID 25197)
-- Name: idx_order_items_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_order_items_product_id ON public.order_items USING btree (product_id);


--
-- TOC entry 4828 (class 1259 OID 25194)
-- Name: idx_orders_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_orders_created_at ON public.orders USING btree (created_at);


--
-- TOC entry 4829 (class 1259 OID 25195)
-- Name: idx_orders_is_cart; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_orders_is_cart ON public.orders USING btree (is_cart);


--
-- TOC entry 4830 (class 1259 OID 25193)
-- Name: idx_orders_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_orders_status ON public.orders USING btree (status);


--
-- TOC entry 4831 (class 1259 OID 25192)
-- Name: idx_orders_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_orders_user_id ON public.orders USING btree (user_id);


--
-- TOC entry 4816 (class 1259 OID 25191)
-- Name: idx_products_bestseller; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_bestseller ON public.products USING btree (is_bestseller);


--
-- TOC entry 4817 (class 1259 OID 25189)
-- Name: idx_products_category; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_category ON public.products USING btree (category);


--
-- TOC entry 4818 (class 1259 OID 25190)
-- Name: idx_products_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_status ON public.products USING btree (status);


--
-- TOC entry 4850 (class 1259 OID 25204)
-- Name: idx_promotion_products_product; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_promotion_products_product ON public.promotion_products USING btree (product_id);


--
-- TOC entry 4851 (class 1259 OID 25203)
-- Name: idx_promotion_products_promotion; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_promotion_products_promotion ON public.promotion_products USING btree (promotion_id);


--
-- TOC entry 4821 (class 1259 OID 25198)
-- Name: idx_promotions_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_promotions_code ON public.promotions USING btree (code);


--
-- TOC entry 4822 (class 1259 OID 25200)
-- Name: idx_promotions_dates; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_promotions_dates ON public.promotions USING btree (start_date, end_date);


--
-- TOC entry 4823 (class 1259 OID 25199)
-- Name: idx_promotions_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_promotions_status ON public.promotions USING btree (status);


--
-- TOC entry 4838 (class 1259 OID 25201)
-- Name: idx_settings_category; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_settings_category ON public.settings USING btree (category);


--
-- TOC entry 4839 (class 1259 OID 25202)
-- Name: idx_settings_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_settings_status ON public.settings USING btree (status);


--
-- TOC entry 4809 (class 1259 OID 25186)
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- TOC entry 4810 (class 1259 OID 25187)
-- Name: idx_users_role; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_role ON public.users USING btree (role);


--
-- TOC entry 4811 (class 1259 OID 25188)
-- Name: idx_users_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_status ON public.users USING btree (status);


--
-- TOC entry 4862 (class 2606 OID 25165)
-- Name: invoices invoices_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id);


--
-- TOC entry 4858 (class 2606 OID 25110)
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id) ON DELETE CASCADE;


--
-- TOC entry 4859 (class 2606 OID 25115)
-- Name: order_items order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- TOC entry 4856 (class 2606 OID 25094)
-- Name: orders orders_promotion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_promotion_id_fkey FOREIGN KEY (promotion_id) REFERENCES public.promotions(promotion_id);


--
-- TOC entry 4857 (class 2606 OID 25089)
-- Name: orders orders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 4861 (class 2606 OID 25147)
-- Name: payments payments_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id);


--
-- TOC entry 4863 (class 2606 OID 25181)
-- Name: promotion_products promotion_products_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_products
    ADD CONSTRAINT promotion_products_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


--
-- TOC entry 4864 (class 2606 OID 25176)
-- Name: promotion_products promotion_products_promotion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_products
    ADD CONSTRAINT promotion_products_promotion_id_fkey FOREIGN KEY (promotion_id) REFERENCES public.promotions(promotion_id) ON DELETE CASCADE;


--
-- TOC entry 4854 (class 2606 OID 25066)
-- Name: promotions promotions_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT promotions_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(user_id);


--
-- TOC entry 4855 (class 2606 OID 25071)
-- Name: promotions promotions_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT promotions_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(user_id);


--
-- TOC entry 4860 (class 2606 OID 25132)
-- Name: settings settings_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(user_id);


-- Completed on 2025-11-12 20:38:01

--
-- PostgreSQL database dump complete
--

\unrestrict ZaCgNWMafHir86RD7dRJedLexvxHOsLJFueVvLrIiHfhAn0yClU64IhbXn6dj8d

