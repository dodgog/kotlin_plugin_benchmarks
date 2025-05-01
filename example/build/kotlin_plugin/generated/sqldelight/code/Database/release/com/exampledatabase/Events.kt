package com.exampledatabase

import kotlin.String

public data class Events(
  public val id: String,
  public val entity_id: String,
  public val attribute: String,
  public val value_: String,
  public val timestamp: String,
)
