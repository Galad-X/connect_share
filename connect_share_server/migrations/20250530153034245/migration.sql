BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "access_token" (
    "id" bigserial PRIMARY KEY,
    "tokenValue" text NOT NULL,
    "consumerId" bigint NOT NULL,
    "hotspotId" bigint NOT NULL,
    "planId" bigint NOT NULL,
    "issueDate" timestamp without time zone NOT NULL,
    "activationDate" timestamp without time zone,
    "expiryDate" timestamp without time zone NOT NULL,
    "isActive" boolean NOT NULL,
    "dataUsedBytes" text,
    "lastUsed" timestamp without time zone,
    "lastUsedDeviceIdentifier" text
);

-- Indexes
CREATE UNIQUE INDEX "access_token_value_unique_idx" ON "access_token" USING btree ("tokenValue");
CREATE INDEX "access_token_consumer_id_is_active_idx" ON "access_token" USING btree ("consumerId", "isActive");
CREATE INDEX "access_token_hotspot_id_idx" ON "access_token" USING btree ("hotspotId");
CREATE INDEX "access_token_expiry_date_idx" ON "access_token" USING btree ("expiryDate");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "feedback" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "type" text NOT NULL,
    "content" text NOT NULL,
    "submittedAt" timestamp without time zone NOT NULL,
    "status" text NOT NULL,
    "response" text,
    "respondedAt" timestamp without time zone,
    "respondedBy" bigint
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "hotspot_config" (
    "id" bigserial PRIMARY KEY,
    "providerId" bigint NOT NULL,
    "name" text NOT NULL,
    "ssid" text,
    "latitude" double precision NOT NULL,
    "longitude" double precision NOT NULL,
    "geofenceRadiusMeters" double precision,
    "isActive" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "lastOnlineAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "hotspot_config_provider_id_idx" ON "hotspot_config" USING btree ("providerId");
CREATE INDEX "hotspot_config_is_active_idx" ON "hotspot_config" USING btree ("isActive");
CREATE INDEX "hotspot_config_lat_lon_idx" ON "hotspot_config" USING btree ("latitude", "longitude");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "plan" (
    "id" bigserial PRIMARY KEY,
    "hotspotId" bigint NOT NULL,
    "name" text NOT NULL,
    "description" text,
    "type" bigint NOT NULL,
    "durationType" bigint NOT NULL,
    "durationValue" bigint NOT NULL,
    "price" double precision NOT NULL,
    "currency" text NOT NULL,
    "dataLimitGB" double precision,
    "bandwidthDownMbps" double precision,
    "bandwidthUpMbps" double precision,
    "isActive" boolean NOT NULL
);

-- Indexes
CREATE INDEX "plan_hotspot_id_is_active_idx" ON "plan" USING btree ("hotspotId", "isActive");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "policy" (
    "id" bigserial PRIMARY KEY,
    "type" text NOT NULL,
    "content" text NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "updatedBy" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "policy_type_idx" ON "policy" USING btree ("type");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "transaction_log" (
    "id" bigserial PRIMARY KEY,
    "consumerId" bigint NOT NULL,
    "providerId" bigint NOT NULL,
    "hotspotId" bigint NOT NULL,
    "planId" bigint NOT NULL,
    "accessTokenId" bigint,
    "paystackReference" text NOT NULL,
    "amountPaid" double precision NOT NULL,
    "currency" text NOT NULL,
    "transactionDate" timestamp without time zone NOT NULL,
    "status" text NOT NULL,
    "platformFee" double precision,
    "providerPayoutAmount" double precision,
    "payoutStatus" text
);

-- Indexes
CREATE UNIQUE INDEX "transaction_log_paystack_ref_idx" ON "transaction_log" USING btree ("paystackReference");
CREATE INDEX "transaction_log_consumer_id_date_idx" ON "transaction_log" USING btree ("consumerId", "transactionDate");
CREATE INDEX "transaction_log_provider_id_payout_status_idx" ON "transaction_log" USING btree ("providerId", "payoutStatus");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_profile" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "paystackAccountId" text,
    "displayName" text NOT NULL,
    "bio" text,
    "hotspotCount" bigint NOT NULL DEFAULT 0,
    "sharedDataLimit" double precision NOT NULL,
    "currentDataUsage" double precision NOT NULL DEFAULT 0,
    "rating" double precision NOT NULL DEFAULT 5.0,
    "isHotspotProvider" boolean NOT NULL DEFAULT false,
    "lastActiveTime" timestamp without time zone,
    "role" text NOT NULL DEFAULT 'consumer'::text
);

-- Indexes
CREATE UNIQUE INDEX "user_profile_user_id_idx" ON "user_profile" USING btree ("userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_key" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "hash" text NOT NULL,
    "scopeNames" json NOT NULL,
    "method" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_auth_key_userId_idx" ON "serverpod_auth_key" USING btree ("userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_email_auth" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "email" text NOT NULL,
    "hash" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_email_auth_email" ON "serverpod_email_auth" USING btree ("email");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_email_create_request" (
    "id" bigserial PRIMARY KEY,
    "userName" text NOT NULL,
    "email" text NOT NULL,
    "hash" text NOT NULL,
    "verificationCode" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_email_auth_create_account_request_idx" ON "serverpod_email_create_request" USING btree ("email");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_email_failed_sign_in" (
    "id" bigserial PRIMARY KEY,
    "email" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "ipAddress" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_email_failed_sign_in_email_idx" ON "serverpod_email_failed_sign_in" USING btree ("email");
CREATE INDEX "serverpod_email_failed_sign_in_time_idx" ON "serverpod_email_failed_sign_in" USING btree ("time");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_email_reset" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "verificationCode" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_email_reset_verification_idx" ON "serverpod_email_reset" USING btree ("verificationCode");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_google_refresh_token" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "refreshToken" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_google_refresh_token_userId_idx" ON "serverpod_google_refresh_token" USING btree ("userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_user_image" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "version" bigint NOT NULL,
    "url" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_user_image_user_id" ON "serverpod_user_image" USING btree ("userId", "version");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_user_info" (
    "id" bigserial PRIMARY KEY,
    "userIdentifier" text NOT NULL,
    "userName" text,
    "fullName" text,
    "email" text,
    "created" timestamp without time zone NOT NULL,
    "imageUrl" text,
    "scopeNames" json NOT NULL,
    "blocked" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_user_info_user_identifier" ON "serverpod_user_info" USING btree ("userIdentifier");
CREATE INDEX "serverpod_user_info_email" ON "serverpod_user_info" USING btree ("email");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "access_token"
    ADD CONSTRAINT "access_token_fk_0"
    FOREIGN KEY("consumerId")
    REFERENCES "serverpod_user_info"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "access_token"
    ADD CONSTRAINT "access_token_fk_1"
    FOREIGN KEY("hotspotId")
    REFERENCES "hotspot_config"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "access_token"
    ADD CONSTRAINT "access_token_fk_2"
    FOREIGN KEY("planId")
    REFERENCES "plan"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "feedback"
    ADD CONSTRAINT "feedback_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "serverpod_user_info"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "feedback"
    ADD CONSTRAINT "feedback_fk_1"
    FOREIGN KEY("respondedBy")
    REFERENCES "serverpod_user_info"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "hotspot_config"
    ADD CONSTRAINT "hotspot_config_fk_0"
    FOREIGN KEY("providerId")
    REFERENCES "serverpod_user_info"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "plan"
    ADD CONSTRAINT "plan_fk_0"
    FOREIGN KEY("hotspotId")
    REFERENCES "hotspot_config"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "policy"
    ADD CONSTRAINT "policy_fk_0"
    FOREIGN KEY("updatedBy")
    REFERENCES "serverpod_user_info"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "transaction_log"
    ADD CONSTRAINT "transaction_log_fk_0"
    FOREIGN KEY("consumerId")
    REFERENCES "serverpod_user_info"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "transaction_log"
    ADD CONSTRAINT "transaction_log_fk_1"
    FOREIGN KEY("providerId")
    REFERENCES "serverpod_user_info"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "transaction_log"
    ADD CONSTRAINT "transaction_log_fk_2"
    FOREIGN KEY("hotspotId")
    REFERENCES "hotspot_config"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "transaction_log"
    ADD CONSTRAINT "transaction_log_fk_3"
    FOREIGN KEY("planId")
    REFERENCES "plan"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "transaction_log"
    ADD CONSTRAINT "transaction_log_fk_4"
    FOREIGN KEY("accessTokenId")
    REFERENCES "access_token"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "user_profile"
    ADD CONSTRAINT "user_profile_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "serverpod_user_info"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR connect_share
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('connect_share', '20250530153034245', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250530153034245', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20240520102713718', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240520102713718', "timestamp" = now();


COMMIT;
