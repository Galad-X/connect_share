BEGIN;

--
-- Class AccessToken as table access_token
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
-- Class Feedback as table feedback
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
-- Class HotspotConfig as table hotspot_config
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
-- Class Plan as table plan
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
-- Class Policy as table policy
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
-- Class TransactionLog as table transaction_log
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
-- Class UserProfile as table user_profile
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
-- Class CloudStorageEntry as table serverpod_cloud_storage
--
CREATE TABLE "serverpod_cloud_storage" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "addedTime" timestamp without time zone NOT NULL,
    "expiration" timestamp without time zone,
    "byteData" bytea NOT NULL,
    "verified" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_path_idx" ON "serverpod_cloud_storage" USING btree ("storageId", "path");
CREATE INDEX "serverpod_cloud_storage_expiration" ON "serverpod_cloud_storage" USING btree ("expiration");

--
-- Class CloudStorageDirectUploadEntry as table serverpod_cloud_storage_direct_upload
--
CREATE TABLE "serverpod_cloud_storage_direct_upload" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL,
    "authKey" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_direct_upload_storage_path" ON "serverpod_cloud_storage_direct_upload" USING btree ("storageId", "path");

--
-- Class FutureCallEntry as table serverpod_future_call
--
CREATE TABLE "serverpod_future_call" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "serializedObject" text,
    "serverId" text NOT NULL,
    "identifier" text
);

-- Indexes
CREATE INDEX "serverpod_future_call_time_idx" ON "serverpod_future_call" USING btree ("time");
CREATE INDEX "serverpod_future_call_serverId_idx" ON "serverpod_future_call" USING btree ("serverId");
CREATE INDEX "serverpod_future_call_identifier_idx" ON "serverpod_future_call" USING btree ("identifier");

--
-- Class ServerHealthConnectionInfo as table serverpod_health_connection_info
--
CREATE TABLE "serverpod_health_connection_info" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "active" bigint NOT NULL,
    "closing" bigint NOT NULL,
    "idle" bigint NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_connection_info_timestamp_idx" ON "serverpod_health_connection_info" USING btree ("timestamp", "serverId", "granularity");

--
-- Class ServerHealthMetric as table serverpod_health_metric
--
CREATE TABLE "serverpod_health_metric" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "isHealthy" boolean NOT NULL,
    "value" double precision NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_metric_timestamp_idx" ON "serverpod_health_metric" USING btree ("timestamp", "serverId", "name", "granularity");

--
-- Class LogEntry as table serverpod_log
--
CREATE TABLE "serverpod_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "reference" text,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "logLevel" bigint NOT NULL,
    "message" text NOT NULL,
    "error" text,
    "stackTrace" text,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_log_sessionLogId_idx" ON "serverpod_log" USING btree ("sessionLogId");

--
-- Class MessageLogEntry as table serverpod_message_log
--
CREATE TABLE "serverpod_message_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "serverId" text NOT NULL,
    "messageId" bigint NOT NULL,
    "endpoint" text NOT NULL,
    "messageName" text NOT NULL,
    "duration" double precision NOT NULL,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

--
-- Class MethodInfo as table serverpod_method
--
CREATE TABLE "serverpod_method" (
    "id" bigserial PRIMARY KEY,
    "endpoint" text NOT NULL,
    "method" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_method_endpoint_method_idx" ON "serverpod_method" USING btree ("endpoint", "method");

--
-- Class DatabaseMigrationVersion as table serverpod_migrations
--
CREATE TABLE "serverpod_migrations" (
    "id" bigserial PRIMARY KEY,
    "module" text NOT NULL,
    "version" text NOT NULL,
    "timestamp" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_migrations_ids" ON "serverpod_migrations" USING btree ("module");

--
-- Class QueryLogEntry as table serverpod_query_log
--
CREATE TABLE "serverpod_query_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "query" text NOT NULL,
    "duration" double precision NOT NULL,
    "numRows" bigint,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_query_log_sessionLogId_idx" ON "serverpod_query_log" USING btree ("sessionLogId");

--
-- Class ReadWriteTestEntry as table serverpod_readwrite_test
--
CREATE TABLE "serverpod_readwrite_test" (
    "id" bigserial PRIMARY KEY,
    "number" bigint NOT NULL
);

--
-- Class RuntimeSettings as table serverpod_runtime_settings
--
CREATE TABLE "serverpod_runtime_settings" (
    "id" bigserial PRIMARY KEY,
    "logSettings" json NOT NULL,
    "logSettingsOverrides" json NOT NULL,
    "logServiceCalls" boolean NOT NULL,
    "logMalformedCalls" boolean NOT NULL
);

--
-- Class SessionLogEntry as table serverpod_session_log
--
CREATE TABLE "serverpod_session_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "module" text,
    "endpoint" text,
    "method" text,
    "duration" double precision,
    "numQueries" bigint,
    "slow" boolean,
    "error" text,
    "stackTrace" text,
    "authenticatedUserId" bigint,
    "isOpen" boolean,
    "touched" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_session_log_serverid_idx" ON "serverpod_session_log" USING btree ("serverId");
CREATE INDEX "serverpod_session_log_touched_idx" ON "serverpod_session_log" USING btree ("touched");
CREATE INDEX "serverpod_session_log_isopen_idx" ON "serverpod_session_log" USING btree ("isOpen");

--
-- Class AuthKey as table serverpod_auth_key
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
-- Class EmailAuth as table serverpod_email_auth
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
-- Class EmailCreateAccountRequest as table serverpod_email_create_request
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
-- Class EmailFailedSignIn as table serverpod_email_failed_sign_in
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
-- Class EmailReset as table serverpod_email_reset
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
-- Class GoogleRefreshToken as table serverpod_google_refresh_token
--
CREATE TABLE "serverpod_google_refresh_token" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "refreshToken" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_google_refresh_token_userId_idx" ON "serverpod_google_refresh_token" USING btree ("userId");

--
-- Class UserImage as table serverpod_user_image
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
-- Class UserInfo as table serverpod_user_info
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
-- Foreign relations for "access_token" table
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
-- Foreign relations for "feedback" table
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
-- Foreign relations for "hotspot_config" table
--
ALTER TABLE ONLY "hotspot_config"
    ADD CONSTRAINT "hotspot_config_fk_0"
    FOREIGN KEY("providerId")
    REFERENCES "serverpod_user_info"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "plan" table
--
ALTER TABLE ONLY "plan"
    ADD CONSTRAINT "plan_fk_0"
    FOREIGN KEY("hotspotId")
    REFERENCES "hotspot_config"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "policy" table
--
ALTER TABLE ONLY "policy"
    ADD CONSTRAINT "policy_fk_0"
    FOREIGN KEY("updatedBy")
    REFERENCES "serverpod_user_info"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "transaction_log" table
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
-- Foreign relations for "user_profile" table
--
ALTER TABLE ONLY "user_profile"
    ADD CONSTRAINT "user_profile_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "serverpod_user_info"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_log" table
--
ALTER TABLE ONLY "serverpod_log"
    ADD CONSTRAINT "serverpod_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_message_log" table
--
ALTER TABLE ONLY "serverpod_message_log"
    ADD CONSTRAINT "serverpod_message_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_query_log" table
--
ALTER TABLE ONLY "serverpod_query_log"
    ADD CONSTRAINT "serverpod_query_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
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
