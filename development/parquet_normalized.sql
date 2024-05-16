-- COM NORMALIZAÇÃO
EXPLAIN ANALYZE
SELECT
    a.scrape_id,
    COUNT(DISTINCT a.id) AS contagem_listings,
    COUNT(DISTINCT b.picture_url) AS contagem_fotos_url,
    COUNT(DISTINCT c.host_name) AS contagem_unicas_de_nomes_de_host,
    COUNT(DISTINCT d.neighbourhood) AS contagem_bairros_unicos,
    AVG(average_review.average_review_scores_rating) AS average_review_scores_rating

FROM read_parquet('data-airbnb/pqt_silver_listings.parquet') AS a
LEFT JOIN
read_parquet('data-airbnb/pqt_silver_media.parquet') AS b
ON a.media_id = b.id
LEFT JOIN
read_parquet('data-airbnb/pqt_silver_host.parquet') AS c
ON a.host_id = c.id
LEFT JOIN
read_parquet('data-airbnb/pqt_silver_address.parquet') AS d
ON a.address_id = d.id
LEFT JOIN (
    SELECT
        a.scrape_id,
        AVG(h.review_scores_rating) AS average_review_scores_rating
    FROM read_parquet('data-airbnb/pqt_silver_listings.parquet') AS a
    LEFT JOIN
    read_parquet('data-airbnb/pqt_silver_review.parquet') AS h
    ON a.review_id = h.id
    WHERE a.scrape_id IN ('20190313042552', '20180414160018')
    GROUP BY a.scrape_id
) AS average_review
ON a.scrape_id = average_review.scrape_id

WHERE a.scrape_id IN ('20190313042552','20180414160018')
GROUP BY a.scrape_id
ORDER BY a.scrape_id;
