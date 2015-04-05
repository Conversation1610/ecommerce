import analytics
from django.conf import settings
from oscar.apps.analytics import config


class AnalyticsConfig(config.AnalyticsConfig):
    name = 'ecommerce.extensions.analytics'

    def ready(self):
        if settings.INSTALL_DEFAULT_ANALYTICS_RECEIVERS:
            from oscar.apps.analytics import receivers  # noqa pylint: disable=unused-variable

        # Initialize Segment
        analytics.write_key = settings.SEGMENT_KEY
        analytics.debug = settings.DEBUG
