-- =============================================================================
-- SEEDS: Currency Rates for EP-009
-- =============================================================================
-- Purpose: Multi-currency support for international projects
-- Source: Standard exchange rates for major currencies
-- Dependencies: None
-- =============================================================================

INSERT INTO masterdata.mst_currency_rates (
    id, from_currency, to_currency, rate, valid_from, valid_until, is_active, source
) VALUES
-- EUR to other currencies (base EUR)
(gen_random_uuid(), 'EUR', 'USD', 1.0850, '2024-01-01'::date, '2024-03-31'::date, true, 'ecb'),
(gen_random_uuid(), 'EUR', 'GBP', 0.8520, '2024-01-01'::date, '2024-03-31'::date, true, 'ecb'),
(gen_random_uuid(), 'EUR', 'JPY', 165.20, '2024-01-01'::date, '2024-03-31'::date, true, 'ecb'),
(gen_random_uuid(), 'EUR', 'CAD', 1.4650, '2024-01-01'::date, '2024-03-31'::date, true, 'ecb'),

-- USD to other currencies (base USD)
(gen_random_uuid(), 'USD', 'EUR', 0.9208, '2024-01-01'::date, '2024-03-31'::date, true, 'ecb'),
(gen_random_uuid(), 'USD', 'GBP', 0.7850, '2024-01-01'::date, '2024-03-31'::date, true, 'ecb'),
(gen_random_uuid(), 'USD', 'JPY', 152.10, '2024-01-01'::date, '2024-03-31'::date, true, 'ecb'),

-- GBP to other currencies (base GBP)
(gen_random_uuid(), 'GBP', 'EUR', 1.1735, '2024-01-01'::date, '2024-03-31'::date, true, 'ecb'),
(gen_random_uuid(), 'GBP', 'USD', 1.2735, '2024-01-01'::date, '2024-03-31'::date, true, 'ecb'),

-- Rates for Q2 2024
(gen_random_uuid(), 'EUR', 'USD', 1.0780, '2024-04-01'::date, '2024-06-30'::date, true, 'ecb'),
(gen_random_uuid(), 'EUR', 'GBP', 0.8580, '2024-04-01'::date, '2024-06-30'::date, true, 'ecb'),
(gen_random_uuid(), 'EUR', 'JPY', 168.50, '2024-04-01'::date, '2024-06-30'::date, true, 'ecb'),

-- Current rates for 2025
(gen_random_uuid(), 'EUR', 'USD', 1.0520, '2025-01-01'::date, NULL, true, 'ecb'),
(gen_random_uuid(), 'EUR', 'GBP', 0.8350, '2025-01-01'::date, NULL, true, 'ecb'),
(gen_random_uuid(), 'EUR', 'JPY', 162.80, '2025-01-01'::date, NULL, true, 'ecb'),
(gen_random_uuid(), 'EUR', 'CAD', 1.4250, '2025-01-01'::date, NULL, true, 'ecb')
ON CONFLICT DO NOTHING;

-- Verify insertion
SELECT 'Currency rates inserted:' as status, COUNT(*) as total_rates FROM masterdata.mst_currency_rates;
